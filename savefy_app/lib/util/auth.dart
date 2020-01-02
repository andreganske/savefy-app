import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';


import 'package:savefy_app/models/settings.dart';
import 'package:savefy_app/models/user.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum authProblems { UserNotFound, PasswordNotValid, NetworkError, UnknownError }

class Auth {

  static FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  static Firestore _firestore = Firestore.instance;

  /* FIREBASE STORAGE */
  static Future<String> signUp(String email, String password) async {
    AuthResult result = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email, password: password);
    return result.user.uid;
  }

  static Future<void> signOut() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    _firebaseAuth.signOut();
  }

  static Future<void> forgotPasswordEmail(String email) async {
    await _firebaseAuth.sendPasswordResetEmail(email: email);
  }

  static Future<String> signIn(String email, String password) async {
    AuthResult result = (await _firebaseAuth
        .signInWithEmailAndPassword(email: email, password: password));
    return result.user.uid;
  }

  static Future<FirebaseUser> getCurrentFirebaseUser() async {
    return await _firebaseAuth.currentUser();
  }

  static Future<void> updateFirebaseUser(User user) async {
    _firebaseAuth.currentUser().then((firebaseUser) {
      firebaseUser.updateEmail(user.email);
    });
  }

  /* FIRESTONE STORAGE */
  static void _addSettings(Settings settings) async {
    _firestore.document("settings/${settings.settingsId}").setData(settings.toJson());
  }

  static void _addUsers(User user) async {
    _firestore.document("users/${user.userId}").setData(user.toJson());
  }

  static void _updateSettings(Settings settings) async {
    _firestore.document("settings/${settings.settingsId}").updateData(settings.toJson());
  }

  static void _updateUsers(User user) async {
    _firestore.document("users/${user.userId}").updateData(user.toJson());
  }

  static Future<void> addUserSettingsDB(User user) async {
    checkUserExist(user.userId).then((value) {
      if (!value) {
        print("user ${user.firstName} ${user.email} added");
        _addUsers(user);
        _addSettings(new Settings(settingsId: user.userId));
      } else {
        print("user ${user.firstName} ${user.email} exists");
        _updateSettings(new Settings(settingsId: user.userId));
        _updateUsers(user);
      }
    });
  }

  static Future<bool> checkUserExist(String userId) async {
    bool exists = false;
    try {
      await _firestore.document("users/$userId").get().then((doc) {
        if (doc.exists)
          exists = true;
        else
          exists = false;
      });
      return exists;
    } catch (e) {
      return false;
    }
  }

  static Future<Settings> getSettingsFirestore(String settingsId) async {
    if (settingsId != null) {
      return _firestore.collection('settings').document(settingsId).get().then((documentSnapshot) => Settings.fromDocument(documentSnapshot));
    } else {
      print('no firestore settings available');
      return null;
    }
  }

  static Future<User> getUserFirestore(String userId) async {
    if (userId != null) {
      return _firestore.collection('users').document(userId).get().then((documentSnapshot) => User.fromDocument(documentSnapshot));
    } else {
      print('firestore userId can not be null');
      return null;
    }
  }

  /* LOCAL STORAGE */
  static Future<String> storeUserLocal(User user) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String storeUser = userToJson(user);
    await prefs.setString('user', storeUser);
    return user.userId;
  }

  static Future<String> storeSettingsLocal(Settings settings) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String storeSettings = settingsToJson(settings);
    await prefs.setString('settings', storeSettings);
    return settings.settingsId;
  }

  static Future<User> getUserLocal() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (prefs.getString('user') != null) {
      User user = userFromJson(prefs.getString('user'));
      return user;
    } else {
      return null;
    }
  }

  static Future<Settings> getSettingsLocal() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (prefs.getString('settings') != null) {
      Settings settings = settingsFromJson(prefs.getString('settings'));
      //print('SETTINGS: $settings');
      return settings;
    } else {
      return null;
    }
  }

  static String getExceptionText(Exception e) {
    if (e is PlatformException) {
      switch (e.message) {
        case 'There is no user record corresponding to this identifier. The user may have been deleted.':
          return 'User with this email address not found.';
          break;
        case 'The password is invalid or the user does not have a password.':
          return 'Invalid password.';
          break;
        case 'A network error (such as timeout, interrupted connection or unreachable host) has occurred.':
          return 'No internet connection.';
          break;
        case 'The email address is already in use by another account.':
          return 'This email address already has an account.';
          break;
        default:
          return 'Unknown error occured.';
      }
    } else {
      return 'Unknown error occured.';
    }
  }

}
