import 'package:bank_app/Modules/UserDataSource.dart';
import 'package:bank_app/Modules/UserModel.dart';

class UserRepository {
  final UserDataSource dataSource;

  UserRepository({required this.dataSource});

  Future<List<User>> getUsers() async {
    final users = await dataSource.getUserData();
    return users;
  }
}
