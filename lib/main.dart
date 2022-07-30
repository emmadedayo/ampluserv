import 'dart:async';
import 'package:ampluserv/pages/Menu/Menus.dart';
import 'package:ampluserv/pages/Screen/viewItems.dart';
import 'package:ampluserv/pages/auth/alogin.dart';
import 'package:flutter/material.dart';
import "package:ampluserv/pages/walkthrough/walk_screen.dart";
import 'package:ampluserv/pages/walkthrough/welcome_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ampluserv/constants/theme.dart';
import 'package:flutter/services.dart';
import 'package:ampluserv/pages/auth/login.dart';
import 'package:ampluserv/pages/auth/Register.dart';
import 'package:ampluserv/pages/auth/Forgot.dart';
import 'package:ampluserv/pages/Menu/Menu.dart';
import 'package:ampluserv/constants/style.dart';
import 'package:ampluserv/pages/Screen/DashBoard.dart';

void main() {
  SharedPreferences.getInstance().then((prefs) {
    runApp(MyApp(prefs: prefs));
  });
}

class MyApp extends StatelessWidget {
  final SharedPreferences prefs;
  MyApp({this.prefs});

  @override
  Widget build(BuildContext context) {
    SystemChrome.setEnabledSystemUIOverlays ([]);
    return MaterialApp(
      title: 'Ampluserv',
      debugShowCheckedModeBanner: false,
      routes: <String, WidgetBuilder>{
        '/walkthrough': (BuildContext context) => new WalkthroughScreen(),
        '/login': (BuildContext context) => new LoginScreen(),
        '/logina': (BuildContext context) => new aLoginScreen(),
        '/welcome': (BuildContext context) => new SplashScreen(),
        '/signup': (BuildContext context) => new SignUpScreen(),
        '/forget': (BuildContext context) => new Forget(),
        '/menu': (BuildContext context) => new Menu(),
        '/menus': (BuildContext context) => new Menus(),


      },
      theme: appTheme,
      home: _handleCurrentScreen(),
    );
  }


  Widget _handleCurrentScreen(){
    bool seen = (prefs.getBool('seen') ?? false);
    if (seen)  {
      return new Menu();
    } else {
      return new WalkthroughScreen(prefs: prefs);
    }
  }
}

