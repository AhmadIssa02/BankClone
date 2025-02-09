import 'package:bank_app/Modules/Transaction/transaction_data_source.dart';
import 'package:bank_app/Modules/Transaction/transaction_model.dart';

class TransactionRepository {
  final TransactionDataSource dataSource = TransactionDataSource();

  Future<List<Transaction>?> getTransactionHistory(int accountNumber) async {
    return await dataSource.getTransactionHistory(accountNumber);
  }

  Future<bool> transferMoney(Transaction transactionDto) async {
    return await dataSource.transferMoney(transactionDto);
  }
}
