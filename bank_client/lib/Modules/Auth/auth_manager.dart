// lib/Modules/Account/auth_manager.dart

import 'package:bank_app/Screens/landing_screen.dart';
import 'package:flutter/material.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:bank_app/Screens/login_screen.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class AuthManager {
  static const String _tokenKey = 'access_token';
  final FlutterSecureStorage secureStorage = FlutterSecureStorage();

  Future<void> saveAccessToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_tokenKey, token);
  }

  Future<String?> getAccessToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_tokenKey);
  }

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
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const LandingScreen()),
    );
  }

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

  Future<void> saveEncryptionKey(String key) async {
    await secureStorage.write(key: "encryption_key", value: key);
  }

  Future<String?> getEncryptionKey() async {
    return await secureStorage.read(key: "encryption_key");
  }
}
