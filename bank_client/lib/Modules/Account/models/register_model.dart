import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:encrypt/encrypt.dart' as encrypt;

class RegisterModel {
  final String firstName;
  final String lastName;
  final String email;
  final String encryptedPassword;

  RegisterModel._({
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.encryptedPassword,
  });

  static Future<RegisterModel> fromPlainText({
    required String firstName,
    required String lastName,
    required String email,
    required String password,
  }) async {
    final encryptedPassword = await encryptPassword(password);
    return RegisterModel._(
      firstName: firstName,
      lastName: lastName,
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
      "firstName": firstName,
      "lastName": lastName,
      "email": email,
      "password": encryptedPassword,
    };
  }
}
