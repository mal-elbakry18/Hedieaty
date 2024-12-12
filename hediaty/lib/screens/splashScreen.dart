import 'dart:async';
import 'package:flutter/material.dart';

//Simple entry page of just the title then routes to the app's home page
//Using the splash screen

class Splash_Front extends StatefulWidget {
  const Splash_Front({super.key});

  @override
  _SplashFrontState createState() => _SplashFrontState();
}

class _SplashFrontState extends State<Splash_Front> {
  @override
  void initState() {
    super.initState();
    Timer(const Duration(seconds: 3), () {
      Navigator.pushReplacementNamed(context, '/Login');
    });
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Colors.orange,
      body: Center(
        child: Text(
          "Hediety",
          style: TextStyle(
              fontSize: 90,
              fontFamily: 'Anton',
              fontWeight: FontWeight.bold,
              color: Colors.white),
        ),
      ),
    );
  }
}
