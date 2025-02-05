import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AccountDetails extends StatelessWidget {
  const AccountDetails({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
          decoration: BoxDecoration(
            color: Theme.of(context).primaryColor,
            borderRadius: BorderRadius.circular(10),
          ),
          child: const Center(
            child: Text(
              "Account Details",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
        ),
        const SizedBox(height: 20),
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
              _buildAccountDetailRow("Name on Account", "Ahmad Issa"),
              _buildAccountDetailRow("IBAN", "GB29XABC10161234567801"),
              _buildAccountDetailRow("Account Number", "1234567890"),
              _buildAccountDetailRow("Date Opened", "01/01/2020"),
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

  Widget _buildAccountDetailRow(String title, String value) {
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
            value,
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
    Name on Account: Ahmad Issa
    IBAN: GB29XABC10161234567801
    Account Number: 1234567890
    Date Opened: 01/01/2020
    ''';

    Clipboard.setData(ClipboardData(text: accountDetails));

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Account details copied to clipboard!'),
      ),
    );
  }
}
