import 'package:bank_app/Modules/Customer/customer_data_source.dart';
import 'package:bank_app/Modules/Customer/customer_model.dart';

class CustomerRepository {
  final CustomerDataSource dataSource = CustomerDataSource();

  // Get customer by email
  Future<Customer?> getCustomerByEmail(String email) async {
    return await dataSource.getCustomerByEmail(email);
  }

  // Get customer by account number
  Future<Customer?> getCustomerByAccountNumber(int accountNumber) async {
    return await dataSource.getCustomerByAccountNumber(accountNumber);
  }
}
