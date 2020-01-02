import 'package:flutter/material.dart';
import 'package:savefy_app/generated/i18n.dart';
import 'package:savefy_app/util/routes.dart';
import 'package:savefy_app/util/state_widget.dart';

class AppDrawer extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          _createHeader(context),
          _createDrawerItem(
            icon: Icons.home,
            text: S.of(context).home,
            onTap: () => Navigator.pushReplacementNamed(context, Routes.home),
          ),
          _createDrawerItem(
            icon: Icons.person,
            text: S.of(context).profile,
            onTap: () => Navigator.pushReplacementNamed(context, Routes.profile),
          ),
          Divider(),
          _createDrawerItem(
            icon: Icons.exit_to_app,
            text: S.of(context).sign_out,
            onTap: () => _signOut(context),
          ),
          // _createDrawerItem(icon: Icons.bug_report, text: 'Report an issue'),
          ListTile(
            title: Text('0.1.0'),
            onTap: () {},
          ),
        ],
      ),
    );
  }

  Widget _createHeader(BuildContext context) {
    return DrawerHeader(
      child: Text(S.of(context).app_title),
      decoration: BoxDecoration(
        color: Colors.blue,
      ),
    );
  }

  Widget _createDrawerItem(
      {IconData icon, String text, GestureTapCallback onTap}) {
    return ListTile(
      title: Row(
        children: <Widget>[
          Icon(icon),
          Padding(
            padding: EdgeInsets.only(left: 8.0),
            child: Text(text),
          )
        ],
      ),
      onTap: onTap,
    );
  }

  _signOut(BuildContext context) async {
    StateWidget.of(context).logOutUser();
    await Navigator.pushNamed(context, Routes.signin);
  }

}