import 'package:bank_app/Modules/Auth/auth_manager.dart';
import 'package:bank_app/Modules/Customer/customer_model.dart';
import 'package:bank_app/Modules/Customer/customer_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:intl/intl.dart'; // Import the intl package

class AccountDetails extends StatefulWidget {
  const AccountDetails({super.key});

  @override
  _AccountDetailsState createState() => _AccountDetailsState();
}

class _AccountDetailsState extends State<AccountDetails> {
  String? name;
  String? IBAN;
  String? accNum;
  String? dateOpened;
  String? email;
  Customer? customer;

  @override
  void initState() {
    super.initState();
    _loadAccountDetails();
  }

  Future<void> _loadAccountDetails() async {
    AuthManager authManager = AuthManager();
    String? token = await authManager.getAccessToken();
    if (token != null && !JwtDecoder.isExpired(token)) {
      Map<String, dynamic> decodedToken = JwtDecoder.decode(token);
      setState(() {
        name = decodedToken['username'];
        dateOpened = _formatDate(decodedToken["dateOpened"]);
        email = decodedToken["email"];
      });
      _getCustomerByEmail();
    } else {
      authManager.handleInvalidToken(context);
    }
  }

  Future<void> _getCustomerByEmail() async {
    if (email != null) {
      try {
        CustomerRepository customerRepository = CustomerRepository();
        Customer? customerData =
            await customerRepository.getCustomerByEmail(email!);
        setState(() {
          customer = customerData;
          IBAN = customerData!.iban;
          accNum = customerData!.accountNumber.toString();
        });
      } catch (e) {
        print("Error fetching customer data: $e");
      }
    }
  }

  String _formatDate(String? dateTimeString) {
    if (dateTimeString == null) return "N/A";

    try {
      DateFormat inputFormat = DateFormat("M/d/yyyy h:mm:ss a");
      DateTime dateTime = inputFormat.parse(dateTimeString);
      DateFormat outputFormat = DateFormat('MM/dd/yyyy');
      return outputFormat.format(dateTime);
    } catch (e) {
      print("Error parsing date: $e");
      return "Invalid date";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.3),
                spreadRadius: 1,
                blurRadius: 6,
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildAccountDetailRow("Name on Account", name ?? "Loading..."),
              _buildAccountDetailRow("IBAN", IBAN ?? "Loading..."),
              _buildAccountDetailRow("Account Number", accNum ?? "Loading..."),
              _buildAccountDetailRow("Date Opened", dateOpened ?? "Loading..."),
              Center(
                child: TextButton(
                  onPressed: () {
                    _copyAccountDetailsToClipboard(context);
                  },
                  child: Text(
                    "Share Account Details",
                    style: TextStyle(
                        color: Theme.of(context).indicatorColor, fontSize: 16),
                  ),
                ),
              )
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildAccountDetailRow(String title, String? value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Colors.grey[700],
            ),
          ),
          Text(
            value ?? '',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Colors.grey[800],
            ),
          ),
        ],
      ),
    );
  }

  void _copyAccountDetailsToClipboard(BuildContext context) {
    String accountDetails = '''
    Account Details:
    Name on Account: ${name ?? ""}
    IBAN: ${IBAN ?? ""}
    Account Number: ${accNum ?? ""}
    Date Opened: ${dateOpened ?? ""}
    ''';

    Clipboard.setData(ClipboardData(text: accountDetails));

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Account details copied to clipboard!'),
      ),
    );
  }
}
