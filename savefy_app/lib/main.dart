import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:savefy_app/ui/screens/forgot_password.dart';
import 'package:savefy_app/ui/screens/home.dart';
import 'package:savefy_app/ui/screens/profile.dart';
import 'package:savefy_app/ui/screens/sign_in.dart';
import 'package:savefy_app/ui/screens/sign_up.dart';
import 'package:savefy_app/ui/theme.dart';
import 'package:savefy_app/util/routes.dart';
import 'package:savefy_app/util/state_widget.dart';

import 'generated/i18n.dart';

class MyApp extends StatelessWidget {

  MyApp() {
    //Navigation.initPaths();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Savefy App",
      theme: buildTheme(),
      //onGenerateRoute: Navigation.router.generator,
      debugShowCheckedModeBanner: false,
      localizationsDelegates: [
        S.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ],
      supportedLocales: S.delegate.supportedLocales,
      routes: {
        Routes.home: (context) => HomeScreen(),
        Routes.profile: (context) => ProfileScreen(),
        Routes.signin: (context) => SignInScreen(),
        Routes.signup: (context) => SignUpScreen(),
        Routes.forgotpassword: (context) => ForgotPasswordScreen(),
      },
    );
  }
}

void main() {
  StateWidget stateWidget = new StateWidget(
    child: new MyApp(),
  );
  runApp(stateWidget);
}
