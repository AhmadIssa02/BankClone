import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:bank_app/Modules/Auth/auth_manager.dart';
import 'package:bank_app/Modules/Transaction/transaction_model.dart';

class TransactionDataSource {
  final String baseUri = "https://localhost:7280/api/Transaction";

  Future<List<Transaction>?> getTransactionHistory(int accountNumber) async {
    final token = await AuthManager().getAccessToken();

    final uri = Uri.parse('$baseUri/history/$accountNumber');
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
        List<Transaction> transactions = (jsonData as List)
            .map((data) => Transaction.fromJson(data))
            .toList();
        return transactions.reversed.toList();
      } else {
        print('Failed to load transaction history: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      print('Error fetching transaction history: $e');
      return null;
    }
  }

  Future<bool> transferMoney(Transaction transactionDto) async {
    final token = await AuthManager().getAccessToken();
    final uri = Uri.parse('$baseUri/transfer');
    try {
      final response = await http.post(
        uri,
        headers: <String, String>{
          "Content-Type": "application/json; charset=UTF-8",
          "Authorization": "Bearer $token",
          'credentials': 'include',
        },
        body: jsonEncode(transactionDto.toJson()),
      );

      if (response.statusCode >= 200 && response.statusCode <= 299) {
        return true;
      } else {
        print('Failed to transfer money: ${response.statusCode}');
        return false;
      }
    } catch (e) {
      print('Error transferring money: $e');
      return false;
    }
  }
}
