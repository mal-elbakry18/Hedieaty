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
import 'package:shared_preferences/shared_preferences.dart';
import '/../controllers/database_controllers/user_preference.dart';


class SignupController {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final UserPreferenceController _userPreferenceController = UserPreferenceController();


  Future<void> signUpWithEmail({
    required String email,
    required String password,
    required String firstName,
    required String lastName,
    required String number, // Made non-nullable for consistency
  }) async {
    try {
      // Validate password
      if (!_isPasswordValid(password)) {
        throw Exception(
            'Password must be at least 8 characters long and include at least one special character.');
      }

      // Validate phone number
      if (!_isPhoneNumberValid(number)) {
        throw Exception(
            'Phone number must start with "0" and be exactly 11 digits long.');
      }

      // Step 1: Create a new user with email and password
      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      print('User created with UID: ${userCredential.user?.uid}');

      // Step 2: Check if the phone number already exists in Firestore
      print('Checking for duplicate phone number...');
      final querySnapshot = await _firestore
          .collection('users')
          .where('number', isEqualTo: number)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        // User created but phone number is already in use
        print('Phone number already in use by another account. Deleting user...');
        await userCredential.user?.delete(); // Roll back user creation
        throw Exception('Phone number is already in use by another account.');
      }

      // Step 3: Initialize Firestore metadata document for user count
      final userIdDoc = _firestore.collection('metadata').doc('user_count');
      int userId = 0;

      // Step 4: Use a transaction to increment and fetch the user ID
      await _firestore.runTransaction((transaction) async {
        final snapshot = await transaction.get(userIdDoc);

        if (snapshot.exists) {
          // If the document exists, get the current count
          final currentId = snapshot.data()?['count'] ?? 0;
          userId = currentId + 1;
        } else {
          // If the document does not exist, initialize it
          userId = 1;
        }
        transaction.set(userIdDoc, {'count': userId});
      });

      print('Generated user ID: $userId');

      // Step 5: Generate a username
      final username = '${firstName}_${lastName}_$userId';
      print('Generated username: $username');

      // Step 6: Store user data in Firestore
      await _firestore.collection('users').doc(userCredential.user!.uid).set({
        'user_id': userId,
        'username': username,
        'first_name': firstName,
        'last_name': lastName,
        'email': email,
        'number': number,
        'created_at': FieldValue.serverTimestamp(),
        'sign_in_method': 'email_password',
      });

      print('User data successfully stored in Firestore');

      // Save user data locally
      await _userPreferenceController.saveUserData(userId, username);

      print('User data saved locally: ID=$userId, Username=$username');
    } catch (e) {
      // Log any errors during signup
      print('Error during sign up: $e');
      throw Exception('Error signing up: $e');
    }
  }

  /// Validate password (at least 8 characters and includes a special character)
  bool _isPasswordValid(String password) {
    final passwordRegex = RegExp(r'^(?=.*[!@#$%^&*(),.?":{}|<>]).{8,}$');
    return passwordRegex.hasMatch(password);
  }

  /// Validate phone number (starts with "0" and is exactly 11 digits)
  bool _isPhoneNumberValid(String number) {
    final phoneRegex = RegExp(r'^0\d{10}$');
    return phoneRegex.hasMatch(number);
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

