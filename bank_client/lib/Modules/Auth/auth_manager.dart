// lib/Modules/Account/auth_manager.dart

import 'package:flutter/material.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:bank_app/Screens/login_screen.dart';

class AuthManager {
  static const String _tokenKey = 'access_token';

  // Save the access token in local storage
  Future<void> saveAccessToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_tokenKey, token);
  }

  // Get the access token from local storage
  Future<String?> getAccessToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_tokenKey);
  }

  // Check if the token is valid
  Future<bool> isTokenValid() async {
    final token = await getAccessToken();

    if (token == null) {
      return false;
    }
    // final jwt = JwtDecoder.decode(token);
    // final expiration = DateTime.fromMillisecondsSinceEpoch(jwt['exp'] * 1000);
    // return DateTime.now().isBefore(expiration);
    if (token == null || JwtDecoder.isExpired(token)) {
      return false;
    }

    return true;
  }

  Future<void> removeAccessToken(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_tokenKey);
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const LoginScreen()),
    );
  }

  // Redirect to login if the token is invalid
  Future<void> handleInvalidToken(BuildContext context) async {
    await removeAccessToken(context);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Session expired. Please log in again.')),
    );
  }

  Future<Map<String, dynamic>> decodeJwtToken(BuildContext context) async {
    final token = await getAccessToken();
    if (token != null && !JwtDecoder.isExpired(token)) {
      Map<String, dynamic> decodedToken = JwtDecoder.decode(token);
      return decodedToken;
    } else {
      handleInvalidToken(context);
      throw Exception("Invalid Token");
    }
  }
}
