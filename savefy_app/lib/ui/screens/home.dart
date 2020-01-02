import 'package:flutter/material.dart';
import 'package:savefy_app/generated/i18n.dart';
import 'package:savefy_app/models/state.dart';
import 'package:savefy_app/ui/screens/sign_in.dart';
import 'package:savefy_app/ui/widgets/drawer.dart';
import 'package:savefy_app/util/state_widget.dart';

class HomeScreen extends StatefulWidget {
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  StateModel appState;
  bool loadingVisible = false;

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
        loadingVisible = true;
      } else {
        loadingVisible = false;
      }

      return Scaffold(
          drawer: AppDrawer(),
          appBar: new AppBar(
              title: new Text(S.of(context).home)
          ),
          body: new Container (
            child: Text("Olá " + appState.user.firstName + " " + appState.user.lastName),
          )
      );
    }
  }
}
