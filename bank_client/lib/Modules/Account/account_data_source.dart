// lib/Modules/Account/account_data_source.dart

// ignore_for_file: avoid_print

import 'dart:convert';
import 'package:bank_app/Modules/Account/models/login_model.dart';
import 'package:bank_app/Modules/Auth/auth_manager.dart';
import 'package:http/http.dart' as http;
import 'package:bank_app/Modules/Account/models/register_model.dart';
import 'package:jwt_decoder/jwt_decoder.dart';

class LoginResultDto {
  final String token;
  final String refreshToken;

  LoginResultDto({required this.token, required this.refreshToken});

  factory LoginResultDto.fromJson(Map<String, dynamic> json) {
    return LoginResultDto(
      token: json['token'],
      refreshToken: json['refreshToken'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'token': token,
      'refreshToken': refreshToken,
    };
  }
}

class AccountDataSource {
  final String baseUri = "https://localhost:7280/api/Account";

  Future<bool> registerAccount(RegisterModel registerModel) async {
    final uri = Uri.parse('$baseUri/Register');

    try {
      final response = await http.post(
        uri,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'credentials': 'include',
        },
        body: jsonEncode(registerModel.toJson()),
      );

      if (response.statusCode >= 200 && response.statusCode <= 299) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      print('Error during registration: $e');
      return false;
    }
  }

  Future<LoginResultDto?> login(LoginModel loginModel) async {
    final uri = Uri.parse('$baseUri/login');

    try {
      final response = await http.post(
        uri,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'credentials': 'include',
        },
        body: jsonEncode(loginModel.toJson()),
      );

      if (response.statusCode >= 200 && response.statusCode <= 299) {
        return LoginResultDto.fromJson(jsonDecode(response.body));
      } else {
        return null;
      }
    } catch (e) {
      print('Error during logging in: $e');
      return null;
    }
  }

  Future<bool> changePassword(String oldPassword, String newPassword) async {
    final token = await AuthManager().getAccessToken();

    final decodedToken = JwtDecoder.decode(token!);
    final email = decodedToken['email'];

    final body = jsonEncode({
      'email': email,
      'oldPassword': oldPassword,
      'newPassword': newPassword,
      'confirmNewPassword': newPassword,
    });

    final uri = Uri.parse('$baseUri/changePassword');
    try {
      final response = await http.post(
        uri,
        headers: <String, String>{
          "Content-Type": "application/json; charset=UTF-8",
          "Authorization": "Bearer $token",
          'credentials': 'include',
        },
        body: body,
      );

      if (response.statusCode == 200) {
        print('Password changed successfully');
        return true;
      } else {
        print('Failed to change password: ${response.statusCode}');
        return false;
      }
    } catch (e) {
      print('Error changing password: $e');
      return false;
    }
  }
}
