import 'package:bank_app/Modules/Customer/customer_data_source.dart';
import 'package:bank_app/Modules/Customer/customer_model.dart';

class CustomerRepository {
  final CustomerDataSource dataSource = CustomerDataSource();

  Future<Customer?> getCustomerByEmail(String email) async {
    final customer = await dataSource.getCustomerByEmail(email);
    return customer;
  }
}
