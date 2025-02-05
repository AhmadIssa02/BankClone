// lib/Modules/Account/account_repository.dart

import 'package:bank_app/Modules/Account/account_data_source.dart';
import 'package:bank_app/Modules/Account/models/login_model.dart';
import 'package:bank_app/Modules/Account/models/register_model.dart';

class AccountRepository {
  final AccountDataSource dataSource = AccountDataSource();

  Future<bool> registerAccount(RegisterModel registerModel) async {
    return await dataSource.registerAccount(registerModel);
  }

  Future<LoginResultDto?> login(LoginModel loginModel) async {
    return await dataSource.login(loginModel);
  }
}
