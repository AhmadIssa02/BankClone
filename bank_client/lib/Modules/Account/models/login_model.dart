import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:encrypt/encrypt.dart' as encrypt;

class LoginModel {
  final String email;
  final String encryptedPassword;

  LoginModel._({
    required this.email,
    required this.encryptedPassword,
  });

  static Future<LoginModel> fromPlainText({
    required String email,
    required String password,
  }) async {
    final encryptedPassword = await encryptPassword(password);
    return LoginModel._(
      email: email,
      encryptedPassword: encryptedPassword,
    );
  }

  static Future<String> encryptPassword(String password) async {
    const FlutterSecureStorage secureStorage = FlutterSecureStorage();
    final String? secretKey = await secureStorage.read(key: "encryption_key");

    if (secretKey == null || secretKey.length != 32) {
      throw Exception("Invalid encryption key! Must be 32 characters long.");
    }

    final key = encrypt.Key.fromUtf8(secretKey);
    final iv = encrypt.IV.fromSecureRandom(16);

    final encrypter =
        encrypt.Encrypter(encrypt.AES(key, mode: encrypt.AESMode.cbc));

    final encrypted = encrypter.encrypt(password, iv: iv);

    return "${iv.base64}:${encrypted.base64}";
  }

  Map<String, dynamic> toJson() {
    return {
      "email": email,
      "password": encryptedPassword,
    };
  }
}
