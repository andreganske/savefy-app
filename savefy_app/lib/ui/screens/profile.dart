import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';

import 'package:savefy_app/generated/i18n.dart';
import 'package:savefy_app/models/state.dart';
import 'package:savefy_app/models/user.dart';
import 'package:savefy_app/ui/screens/sign_in.dart';
import 'package:savefy_app/ui/widgets/drawer.dart';
import 'package:savefy_app/ui/widgets/loading.dart';
import 'package:savefy_app/util/routes.dart';
import 'package:savefy_app/util/state_widget.dart';

class ProfileScreen extends StatefulWidget {
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  StateModel appState;
  bool _loadingVisible = false;

  final _email = TextEditingController();
  final _firstName = TextEditingController();
  final _lastName = TextEditingController();
  final _password = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  Future<void> _changeLoadingVisible() async {
    setState(() {
      _loadingVisible = !_loadingVisible;
    });
  }

  Widget _buildScaffold() {
    return Scaffold(
        backgroundColor: Colors.white,
        drawer: AppDrawer(),
        appBar: new AppBar(
            title: new Text(S.of(context).profile)
        ),
        body: LoadingScreen(
            child: _buildForm(),
            inAsyncCall: _loadingVisible,
        ));
  }

  Widget _buildForm() {
    return Form(
        child: ListView(
          children: <Widget>[
            _buildListTile(S.of(context).first_name, _firstName),
            _buildListTile(S.of(context).last_name, _lastName),
            _buildListTile(S.of(context).email, _email),
            _buildListTile(S.of(context).password, _password),
            _updateUserDataButton(),
            _signOutLabel(),
          ],
        ),
    );
  }

  Widget _buildListTile (String leading, TextEditingController controller) {
    return  ListTile(
      leading: Container(
          child: Text(leading.toUpperCase(),
            style: TextStyle(fontWeight: FontWeight.w300)),
          width: 80.0,
      ),
      title: TextFormField(
        controller: controller,
      ),
    );
  }

  Widget _updateUserDataButton() {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 24.0, horizontal: 16.0),
      child: RaisedButton(
        onPressed: () {
          _updateUserData();
        },
        color: Theme.of(context).primaryColor,
        child: Text(S.of(context).update_user_info.toUpperCase(),
            style: TextStyle(color: Colors.white)),
      ),
    );
  }

  Widget _signOutLabel(){
    return FlatButton(
      child: Text(
        S.of(context).sign_out.toUpperCase(),
        style: TextStyle(color: Colors.black54),
      ),
      onPressed:() async {
        StateWidget.of(context).logOutUser();
        await Navigator.pushNamed(context, Routes.signin);
      },
    );
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

      _email.text = appState?.firebaseUserAuth?.email ?? '';
      _firstName.text = appState?.user?.firstName ?? '';
      _lastName.text = appState?.user?.lastName ?? '';
      _password.text = "*********";

      return _buildScaffold();
    }
  }

  _updateUserData() async {
    User user = new User.fromJson({
      "userId": appState.firebaseUserAuth.uid,
      "firstName": _firstName.text.trim(),
      "lastName": _lastName.text.trim(),
      "email":  _email.text.trim(),
    });

    try {
      _changeLoadingVisible();
      await StateWidget.of(context).updateUser(user);
      appState = StateWidget.of(context).state;
      _showSuccessDialog();

    } catch (e) {
      _changeLoadingVisible();
      print(S.of(context).sign_in_error_e(e.toString()));
      Flushbar(
        title: S.of(context).sign_in_error,
        message: e.toString(),
        duration: Duration(seconds: 10),
      )..show(context);
    }
  }

  _showSuccessDialog() {
    _changeLoadingVisible();
    Flushbar(
      title: S.of(context).success.toUpperCase(),
      message: S.of(context).user_profile_updated,
      duration: Duration(seconds: 5),
      backgroundColor: Colors.lightGreen,
    )..show(context);
  }

}