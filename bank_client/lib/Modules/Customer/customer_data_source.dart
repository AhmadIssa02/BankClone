import 'dart:convert';
import 'package:bank_app/Modules/Customer/customer_model.dart';
import 'package:http/http.dart' as http;
import 'package:bank_app/Modules/Auth/auth_manager.dart';
import 'package:jwt_decoder/jwt_decoder.dart';

class CustomerDataSource {
  final String baseUri = "https://localhost:7280/api/Customer";

  Future<Customer?> getCustomerByEmail(String email) async {
    final token = await AuthManager().getAccessToken();

    final uri = Uri.parse('$baseUri/$email');
    try {
      final response = await http.get(
        uri,
        headers: <String, String>{
          "Content-Type": "application/json; charset=UTF-8",
          "Authorization": "Bearer $token",
        },
      );

      if (response.statusCode >= 200 && response.statusCode <= 299) {
        final jsonData = jsonDecode(response.body);
        return Customer.fromJson(jsonData);
      } else {
        print('Failed to load customer: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      print('Error fetching customer: $e');
      return null;
    }
  }
}
