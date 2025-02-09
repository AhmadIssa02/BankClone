import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:bank_app/Modules/Auth/auth_manager.dart';
import 'package:bank_app/Modules/Transaction/transaction_data_source.dart';
import 'package:bank_app/Modules/Transaction/transaction_model.dart';
import 'package:bank_app/Modules/Transaction/transaction_repository.dart';
import 'package:bank_app/Modules/Customer/customer_repository.dart';
import 'package:bank_app/Modules/Customer/customer_model.dart';

class TransactionHistory extends StatefulWidget {
  const TransactionHistory({super.key});

  @override
  State<TransactionHistory> createState() => _TransactionHistoryState();
}

class _TransactionHistoryState extends State<TransactionHistory> {
  final TransactionRepository transactionRepository = TransactionRepository();
  final CustomerRepository customerRepository = CustomerRepository();
  List<Transaction>? transactions;
  bool isLoading = true;
  int? userAccountNumber;

  @override
  void initState() {
    super.initState();
    _loadTransactionHistory();
  }

  Future<void> _loadTransactionHistory() async {
    AuthManager authManager = AuthManager();
    try {
      Map<String, dynamic> decodedToken =
          await authManager.decodeJwtToken(context);

      if (decodedToken['accNum'] == null) {
        throw Exception('Account number not found in token');
      }

      int accNum = int.parse(decodedToken['accNum']);
      userAccountNumber = accNum;

      final fetchedTransactions =
          await transactionRepository.getTransactionHistory(accNum);
      setState(() {
        transactions = fetchedTransactions;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      print('Error fetching transaction history: $e');
    }
  }

  Future<String> _getCustomerName(int accountNumber) async {
    Customer? customer =
        await customerRepository.getCustomerByAccountNumber(accountNumber);
    String name = customer!.firstName + customer!.lastName;
    return name;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Latest Transactions',
            style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).primaryColor),
          ),
          const SizedBox(
            height: 15,
          ),
          isLoading
              ? const Center(child: CircularProgressIndicator())
              : transactions == null || transactions!.isEmpty
                  ? Center(
                      child: Text(
                      'No transactions available.',
                      style: TextStyle(
                          color: Theme.of(context).primaryColor, fontSize: 20),
                    ))
                  : ListView.builder(
                      shrinkWrap: true,
                      itemCount: transactions!.length,
                      itemBuilder: (context, index) {
                        final transaction = transactions![index];
                        bool isIncoming = userAccountNumber ==
                            transaction.receiverAccountNumber;

                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8.0),
                          child: Container(
                            padding: const EdgeInsets.all(15),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(8),
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
                                FutureBuilder<String>(
                                  future: !isIncoming
                                      ? _getCustomerName(
                                          transaction.receiverAccountNumber)
                                      : _getCustomerName(
                                          transaction.senderAccountNumber),
                                  builder: (context, snapshot) {
                                    if (snapshot.connectionState ==
                                        ConnectionState.waiting) {
                                      return Text('Loading...');
                                    } else if (snapshot.hasError) {
                                      return Text('Error loading customer');
                                    } else {
                                      return Text(
                                        snapshot.data!,
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                          color: Theme.of(context).primaryColor,
                                        ),
                                      );
                                    }
                                  },
                                ),
                                SizedBox(height: 5),
                                Text(
                                  transaction.description ?? 'No description',
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                    color: Theme.of(context).primaryColor,
                                  ),
                                ),
                                Align(
                                  alignment: Alignment.centerRight,
                                  child: Text(
                                    isIncoming
                                        ? '+\$${transaction.amount}'
                                        : '-\$${transaction.amount}',
                                    style: TextStyle(
                                      color: isIncoming
                                          ? Colors.green
                                          : Colors.red,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
        ],
      ),
    );
  }
}
