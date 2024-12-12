import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'screens/splashScreen.dart';
import 'screens/login.dart';
import '../view/screens/loginScreen.dart';
import '../view/screens/signUpScreen.dart';
import '../view/screens/homeScreen.dart';

//TO DO :
// Implement the routing
// Import all the screens
// Start tests to test the flow


void main() async  {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
runApp(Hediety());}

class Hediety extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: '/signUp',
      routes: {
        '/': (context) => const Splash_Front(),
        '/login': (context) => LoginScreen(),
        '/signUp': (context) => SignupScreen(),
        '/home':(context) => HomeScreen(),
        //'/Login': (context) => LoginPage(),
        //'/Events': (context) => EventsPage(),

      },
    );
  }
}


