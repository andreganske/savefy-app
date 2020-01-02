import 'package:firebase_auth/firebase_auth.dart';
import 'package:savefy_app/models/settings.dart';
import 'package:savefy_app/models/user.dart';

class StateModel {

  bool isLoading;
  FirebaseUser firebaseUserAuth;
  User user;
  Settings settings;

  StateModel.define(firebaseUserAuth, user, settings) {
    this.isLoading = false;
    this.firebaseUserAuth = firebaseUserAuth;
    this.user = user;
    this.settings = settings;
  }

  StateModel({
    this.isLoading = false,
    this.firebaseUserAuth,
    this.user,
    this.settings,
  });
}
