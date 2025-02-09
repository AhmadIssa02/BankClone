import 'package:bank_app/Modules/AccountBalance/account_balance_data_source.dart';
import 'package:bank_app/Modules/AccountBalance/account_balance_model.dart';

class AccountBalanceRepository {
  final AccountBalanceDataSource dataSource = AccountBalanceDataSource();

  Future<AccountBalance?> getAccountBalance(String customerId) async {
    return await dataSource.getAccountBalance(customerId);
  }
}
