import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:bank_app/Modules/AccountBalance/account_balance_model.dart';
import 'package:bank_app/Modules/Auth/auth_manager.dart';

class AccountBalanceDataSource {
  final String baseUri = "https://localhost:7280/api/AccountBalance";

  Future<AccountBalance?> getAccountBalance(String customerId) async {
    final token = await AuthManager().getAccessToken();

    final uri = Uri.parse('$baseUri/$customerId');
    try {
      final response = await http.get(
        uri,
        headers: <String, String>{
          "Content-Type": "application/json; charset=UTF-8",
          "Authorization": "Bearer $token",
          'credentials': 'include',
        },
      );

      if (response.statusCode >= 200 && response.statusCode <= 299) {
        final jsonData = jsonDecode(response.body);
        return AccountBalance.fromJson(jsonData);
      } else {
        print('Failed to load account balance: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      print('Error fetching account balance: $e');
      return null;
    }
  }
}
