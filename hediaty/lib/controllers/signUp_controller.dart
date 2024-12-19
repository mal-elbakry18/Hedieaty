/*import 'package:flutter/material.dart';
import '../model/firebase/auth_services.dart';

class SignupController {
  final AuthService _authService = AuthService();

  Future<void> signUp({
    required BuildContext context,
    required String email,
    required String password,
    required String name,
  }) async {
    try {
      await _authService.signUpWithEmail(email, password, name);
      Navigator.pushReplacementNamed(context, '/home');
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Signup failed: ${e.toString()}')),
      );
    }
  }
}*/
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_sign_in/google_sign_in.dart';

class SignupController {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  // Email and Password Signup
  Future<void> signUpWithEmail({
    required String email,
    required String password,
    required String firstName,
    required String lastName,
    String? number,
  }) async {
    try {
      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Store user data in Firestore
      await _firestore.collection('users').doc(userCredential.user!.uid).set({
        'first_name': firstName,
        'last_name': lastName,
        'email': email,
        'number': number,
        'created_at': FieldValue.serverTimestamp(),
        'sign_in_method': 'email_password',
      });
    } catch (e) {
      throw Exception('Error signing up: $e');
    }
  }

  // Google Sign-In
  Future<void> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) return; // User canceled the sign-in

      final GoogleSignInAuthentication googleAuth =
      await googleUser.authentication;

      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      UserCredential userCredential =
      await _auth.signInWithCredential(credential);

      // Check if user exists in Firestore
      DocumentSnapshot userDoc = await _firestore
          .collection('users')
          .doc(userCredential.user!.uid)
          .get();

      if (!userDoc.exists) {
        // Store user data in Firestore if it's a new user
        await _firestore.collection('users').doc(userCredential.user!.uid).set({
          'first_name': googleUser.displayName?.split(' ').first ?? '',
          'last_name': googleUser.displayName?.split(' ').last ?? '',
          'email': googleUser.email,
          'number': null,
          'created_at': FieldValue.serverTimestamp(),
          'sign_in_method': 'google',
        });
      }
    } catch (e) {
      throw Exception('Error signing in with Google: $e');
    }
  }
}

