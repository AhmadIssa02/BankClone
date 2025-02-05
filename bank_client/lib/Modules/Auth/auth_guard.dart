import 'package:bank_app/Modules/Auth/auth_manager.dart';
import 'package:flutter/material.dart';
import 'package:bank_app/Screens/login_screen.dart';

Future<void> authGuard(BuildContext context) async {
  AuthManager authManager = AuthManager();

  bool isValid = await authManager.isTokenValid();
  print("authguard checking");

  if (!isValid) {
    await authManager.handleInvalidToken(context);
  }
}
