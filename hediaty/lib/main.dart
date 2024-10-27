import 'package:flutter/material.dart';
import 'dart:async';
import 'screens /home_screen.dart';
import 'screens /splashScreen.dart';
import 'screens /login.dart';
//TO DO :
// Implement the routing
// Import all the screens
// Start tests to test the flow


void main() => runApp(Hediety());

class Hediety extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: '/',
      routes: {
        '/': (context) => Splash_Front(),
        '/Login': (context) => LoginPage(),
        //'/Login': (context) => LoginPage(),
        //'/Events': (context) => EventsPage(),

      },
    );
  }
}


