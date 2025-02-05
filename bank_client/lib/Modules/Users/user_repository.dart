import 'package:bank_app/Modules/Users/user_data_source.dart';
import 'package:bank_app/Modules/Users/user_model.dart';

class UserRepository {
  final UserDataSource dataSource = UserDataSource();

  Future<List<User>> getUsers() async {
    final users = await dataSource.getUserData();
    return users;
  }
}
