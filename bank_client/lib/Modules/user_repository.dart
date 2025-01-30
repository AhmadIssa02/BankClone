import 'package:bank_app/Modules/user_data_source.dart';
import 'package:bank_app/Modules/user_model.dart';

class UserRepository {
  final UserDataSource dataSource;

  UserRepository({required this.dataSource});

  Future<List<User>> getUsers() async {
    final users = await dataSource.getUserData();
    return users;
  }
}
