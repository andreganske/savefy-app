import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:savefy_app/models/state.dart';

import 'state_user.dart';


class StateWidget extends StatefulWidget {
  final StateModel state;
  final Widget child;

  StateWidget({
    @required this.child,
    this.state,
  });

  // Returns data of the nearest widget _StateDataWidget
  // in the widget tree.
  static _StateWidgetState of(BuildContext context) {
    return (context.inheritFromWidgetOfExactType(_StateDataWidget)
            as _StateDataWidget)
        .data;
  }

  @override
  _StateWidgetState createState() => new _StateWidgetState();
}

class _StateWidgetState extends State<StateWidget> {
  StateModel state;
  //GoogleSignInAccount googleAccount;
  //final GoogleSignIn googleSignIn = new GoogleSignIn();

  @override
  void initState() {
    super.initState();
    if (widget.state != null) {
      state = widget.state;
    } else {
      state = new StateModel(isLoading: true);
      initUser();
    }
  }

  Future<Null> initUser() async {
    UserState.initUser().then((userState) {
      setState(() {
        state.isLoading = false;
        state.firebaseUserAuth = userState.firebaseUserAuth;
        state.user = userState.user;
        state.settings = userState.settings;
      });
    });
  }


  Future<void> logOutUser() async {
    UserState.logOutUser().then((userState) {
      setState(() {
        state.isLoading = false;
        state.firebaseUserAuth = userState.firebaseUserAuth;
        state.user = userState.user;
        state.settings = userState.settings;
      });
    });

  }

  Future<void> logInUser(email, password) async {
    UserState.logInUser(email, password).then((userState) {
      setState(() {
        state.isLoading = false;
        state.firebaseUserAuth = userState.firebaseUserAuth;
        state.user = userState.user;
        state.settings = userState.settings;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return new _StateDataWidget(
      data: this,
      child: widget.child,
    );
  }
}

class _StateDataWidget extends InheritedWidget {
  final _StateWidgetState data;

  _StateDataWidget({
    Key key,
    @required Widget child,
    @required this.data,
  }) : super(key: key, child: child);

  // Rebuild the widgets that inherit from this widget
  // on every rebuild of _StateDataWidget:
  @override
  bool updateShouldNotify(_StateDataWidget old) => true;
}
