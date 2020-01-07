import 'package:firebase_auth/firebase_auth.dart';
import 'package:savefy_app/models/settings.dart';
import 'package:savefy_app/models/state.dart';
import 'package:savefy_app/models/user.dart';

import '../service/auth.dart';


class UserState {

  static Future<StateModel> initUser() async {
    print('...initUser...');
    FirebaseUser firebaseUserAuth = await Auth.getCurrentFirebaseUser();
    User user = await Auth.getUserLocal();
    Settings settings = await Auth.getSettingsLocal();
    return StateModel.define(firebaseUserAuth, user, settings);
  }

  static Future<StateModel> logOutUser() async {
    print('...logOutUser...');
    await Auth.signOut();
    return initUser();
  }

  static Future<StateModel> logInUser(email, password) async {
    print('...logInUser...');
    String userId = await Auth.signIn(email, password);
    User user = await Auth.getUserFirestore(userId);
    await Auth.storeUserLocal(user);
    Settings settings = await Auth.getSettingsFirestore(userId);
    await Auth.storeSettingsLocal(settings);
    return initUser();
  }

  static Future<StateModel> signUpUser(email, password, firstName, lastName) async {
    print('...signUpUser...');
    await Auth.signUp(email, password).then((uID) {
      Auth.addUserSettingsDB(new User(
        userId: uID,
        email: email,
        firstName: firstName,
        lastName: lastName,
      ));
    });
    return logInUser(email, password);
  }

  static Future<StateModel> updateUser(User user) async {
    print('...updateUser...');
    Auth.addUserSettingsDB(user);
    Settings settings = await Auth.getSettingsFirestore(user.userId);
    Auth.storeSettingsLocal(settings);
    await Auth.storeUserLocal(user);
    return initUser();
  }

}