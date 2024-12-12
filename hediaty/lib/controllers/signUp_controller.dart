import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../model/firebase/auth_services.dart';
import '../../model/firebase/firestore_Services.dart';

class SignupController {
  Future<void> signUpWithEmail({
    required BuildContext context,
    required String email,
    required String password,
    required String name, // Collect user's name
  }) async {
    try {
      final auth = Provider.of<AuthService>(context, listen: false);
      final firestore = Provider.of<FirestoreService>(context, listen: false);

      // Create the user
      final user = await auth.signUpWithEmail(email, password);

      // Add user data to Firestore
      if (user != null) {
        await firestore.addUser(user.uid, {
          'name': name,
          'email': email,
          'createdAt': DateTime.now().toIso8601String(),
        });
      }
    } catch (e) {
      throw e;
    }
  }
}
