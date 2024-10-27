import 'dart:async';
import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        backgroundColor: Colors.teal.withOpacity(0.85),
        body: Column(
          children: [
            Container(
              width: double.infinity,
              height: 160,
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(45),
                    bottomRight: Radius.circular(45),
                  )),
              child: Center(
                child: Text(
                  "Log In",
                  style: TextStyle(
                      fontSize: 70,
                      fontFamily: 'Anton',
                      fontWeight: FontWeight.bold,
                      color: Colors.teal.withOpacity(0.7)),
                ),
              ),
            ),
            const SizedBox(
              height: 70,
            ),
            TextField(
              decoration: InputDecoration(
                hintText: 'Username',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
                filled: true,
                fillColor: Colors.white.withOpacity(0.9),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            TextField(
              decoration: InputDecoration(
                hintText: 'Password',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
                filled: true,
                fillColor: Colors.white.withOpacity(0.9),
              ),
            ),
            const SizedBox(
              height: 40,
            ),
            ElevatedButton(
                onPressed: () {
                  //check it works
                  print("Login Clicked button");
                },
                child: Text('Login')),
            const SizedBox(
              height: 10,
              width: 10,
            ),
            TextButton(
                onPressed: () {
                  //check it works
                  print("Forget Clicked button");
                },
                child: Text('Forget Password ?')),

            const Text(
              " Or Sign In with ",
              style: TextStyle(
                fontSize: 22,
              ),
            ),
            //Added alternative ways to login/ sign in
            Row(
              children: [
                const SizedBox(
                  height: 22,
                  width: 80,
                ),
                ElevatedButton(
                  onPressed: () {},
                  child: Column(children: [
                    Image.asset("assests/images/Google_Icons-09-512.jpeg",
                        width: 22, height: 22),
                    Text('Google'),
                  ]),
                ),
                const SizedBox(
                  height: 22,
                  width: 60,
                ),
                ElevatedButton(
                  onPressed: () {},
                  child: Column(children: [
                    Image.asset("assests/images/facebook_logo.jpeg",
                        width: 22, height: 22),
                    Text('Facebook'),
                  ]),
                ),
              ],
            ),
            TextButton(
              onPressed: () {
                //check it works
                print("SignUp");
              },
              child: Text("Don't have account ? Sign Up"),
            )
          ], // Column children
        ),
      ),
    );
  }
}
