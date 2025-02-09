import 'package:bank_app/Modules/Auth/auth_manager.dart';
import 'package:flutter/material.dart';
import 'package:bank_app/Modules/AccountBalance/account_balance_model.dart';
import 'package:bank_app/Modules/AccountBalance/account_balance_repository.dart';

class BalanceCard extends StatefulWidget {
  const BalanceCard({super.key});

  @override
  _BalanceCardState createState() => _BalanceCardState();
}

class _BalanceCardState extends State<BalanceCard> {
  double? balance;
  String? customerId;

  @override
  void initState() {
    super.initState();
    _loadAccountBalance();
  }

  Future<void> _loadAccountBalance() async {
    AuthManager authManager = AuthManager();
    try {
      Map<String, dynamic> decodedToken =
          await authManager.decodeJwtToken(context);
      customerId = decodedToken['id'];
      AccountBalanceRepository accountBalanceRepository =
          AccountBalanceRepository();
      AccountBalance? accountBalance =
          await accountBalanceRepository.getAccountBalance(customerId!);
      setState(() {
        if (accountBalance != null) {
          balance = accountBalance.balance;
        }
      });
    } catch (e) {
      print("Error fetching account balance: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(25),
      ),
      child: Container(
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [
              Color.fromARGB(255, 41, 59, 75),
              Color.fromARGB(255, 98, 109, 120)
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Padding(
          padding: const EdgeInsets.only(top: 50.0, left: 25, bottom: 25),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'TOTAL ACCOUNT BALANCE',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w300,
                  color: Colors.grey[350],
                ),
              ),
              const SizedBox(height: 6),
              RichText(
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: balance != null ? '$balance ' : 'Loading...',
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    TextSpan(
                      text: 'JOD',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w400,
                        color: Colors.grey[350],
                      ),
                    )
                  ],
                ),
              ),
              const SizedBox(height: 6),
            ],
          ),
        ),
      ),
    );
  }
}
