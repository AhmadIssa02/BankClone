import 'package:bank_app/Modules/Auth/auth_manager.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:jwt_decoder/jwt_decoder.dart';

Future<void> authGuard(BuildContext context) async {
  AuthManager authManager = AuthManager();

  bool isValid = await authManager.isTokenValid();
  print("authguard checking");

  if (!isValid) {
    await authManager.handleInvalidToken(context);
    return;
  }

  bool isTokenExpiringSoon = await _isTokenExpiringSoon(authManager);

  if (isTokenExpiringSoon) {
    await _refreshToken(authManager, context);
  }
}

Future<bool> _isTokenExpiringSoon(AuthManager authManager) async {
  final token = await authManager.getAccessToken();

  final decodedToken = JwtDecoder.decode(token!);
  final expirationTime =
      DateTime.fromMillisecondsSinceEpoch(decodedToken['exp'] * 1000);
  final currentTime = DateTime.now();

  return expirationTime.isBefore(currentTime.add(const Duration(minutes: 5)));
}

Future<void> _refreshToken(
    AuthManager authManager, BuildContext context) async {
  final token = await authManager.getAccessToken();

  try {
    final response = await http.post(
      Uri.parse('https://localhost:7280/api/Account/refreshtoken'),
      headers: {
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      final responseData = json.decode(response.body);
      final newAccessToken = responseData['token'];

      await authManager.saveAccessToken(newAccessToken);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Access token refreshed')),
      );
    } else {
      throw Exception('Failed to refresh token');
    }
  } catch (e) {
    print('Error refreshing token: $e');
    authManager.handleInvalidToken(context);
  }
}
