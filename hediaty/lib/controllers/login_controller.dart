import 'package:flutter/material.dart';

import 'package:provider/provider.dart';
import '../../model/firebase/auth_services.dart';

class LoginController {
  Future<void> loginWithEmail({
    required BuildContext context,
    required String email,
    required String password,
  }) async {
    final auth = Provider.of<AuthService>(context, listen: false);
    await auth.loginWithEmail(email, password);
  }

  Future<void> loginWithGoogle(BuildContext context) async {
    final auth = Provider.of<AuthService>(context, listen: false);
    await auth.signInWithGoogle();
  }
}

