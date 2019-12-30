import 'package:flutter/material.dart';
import 'package:savefy_app/generated/i18n.dart';
import 'package:savefy_app/models/state.dart';
import 'package:savefy_app/ui/screens/sign_in.dart';
import 'package:savefy_app/ui/widgets/loading.dart';
import 'package:savefy_app/util/routes.dart';
import 'package:savefy_app/util/state_widget.dart';

class HomeScreen extends StatefulWidget {
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  StateModel appState;
  bool _loadingVisible = false;
  @override
  void initState() {
    super.initState();
  }

  Widget build(BuildContext context) {
    appState = StateWidget.of(context).state;
    if (!appState.isLoading &&
        (appState.firebaseUserAuth == null ||
            appState.user == null ||
            appState.settings == null)) {
      return SignInScreen();
    } else {
      if (appState.isLoading) {
        _loadingVisible = true;
      } else {
        _loadingVisible = false;
      }
      final logo = Hero(
        tag: 'hero',
        child: CircleAvatar(
            backgroundColor: Colors.transparent,
            radius: 60.0,
            child: ClipOval(
              child: Image.asset(
                'assets/images/default.png',
                fit: BoxFit.cover,
                width: 120.0,
                height: 120.0,
              ),
            )),
      );

      final signOutButton = Padding(
        padding: EdgeInsets.symmetric(vertical: 16.0),
        child: RaisedButton(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
          ),
          onPressed: () {
            StateWidget.of(context).logOutUser();
          },
          padding: EdgeInsets.all(12),
          color: Theme.of(context).primaryColor,
          child: Text(S.of(context).sign_out, 
              style: TextStyle(color: Colors.white)
          ),
        ),
      );

      final forgotLabel = FlatButton(
        child: Text(
          S.of(context).forgot_password,
          style: TextStyle(color: Colors.black54),
        ),
        onPressed: () {
          Navigator.pushNamed(context, '/forgot-password');
        },
      );

      final signUpLabel = FlatButton(
        child: Text(
          S.of(context).sign_up,
          style: TextStyle(color: Colors.black54),
        ),
        onPressed: () {
          Navigator.pushNamed(context, '/signup');
        },
      );

      final signInLabel = FlatButton(
        child: Text(
          S.of(context).sign_in,
          style: TextStyle(color: Colors.black54),
        ),
        onPressed: () {
          Navigator.pushNamed(context, '/signin');
        },
      );

      final profileLabel = FlatButton(
        child: Text(
          S.of(context).profile,
          style: TextStyle(color: Colors.black54),
        ),
        onPressed: () {
          Navigator.pushNamed(context, Routes.profile);
        },
      );

//check for null https://stackoverflow.com/questions/49775261/check-null-in-ternary-operation
      final userId = appState?.firebaseUserAuth?.uid ?? '';
      final email = appState?.firebaseUserAuth?.email ?? '';
      final firstName = appState?.user?.firstName ?? '';
      final lastName = appState?.user?.lastName ?? '';
      final settingsId = appState?.settings?.settingsId ?? '';

      return Scaffold(
        backgroundColor: Colors.white,
        body: LoadingScreen(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 48.0),
              child: Center(
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      logo,
                      SizedBox(height: 48.0),
                      Text(S.of(context).app_id_),
                      Text(userId,
                          style: TextStyle(fontWeight: FontWeight.bold)),
                      SizedBox(height: 12.0),
                      Text(S.of(context).email + ": "),
                      Text(email,
                          style: TextStyle(fontWeight: FontWeight.bold)),
                      SizedBox(height: 12.0),
                      Text(S.of(context).first_name + ": "),
                      Text(firstName,
                          style: TextStyle(fontWeight: FontWeight.bold)),
                      SizedBox(height: 12.0),
                      Text(S.of(context).last_name + ": "),
                      Text(lastName,
                          style: TextStyle(fontWeight: FontWeight.bold)),
                      SizedBox(height: 12.0),
                      Text(S.of(context).setttings_id),
                      Text(settingsId,
                          style: TextStyle(fontWeight: FontWeight.bold)),
                      SizedBox(height: 12.0),
                      signOutButton,
                      profileLabel,
                    ],
                  ),
                ),
              ),
            ),
            inAsyncCall: _loadingVisible),
      );
    }
  }
}
