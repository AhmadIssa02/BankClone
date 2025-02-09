// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:bank_app/Modules/Transaction/transaction_model.dart';
import 'package:bank_app/Modules/Transaction/transaction_repository.dart';
import 'package:bank_app/Modules/Auth/auth_manager.dart';

class TransactionScreen extends StatefulWidget {
  const TransactionScreen({super.key});

  @override
  State<StatefulWidget> createState() {
    return _TransactionScreenState();
  }
}

class _TransactionScreenState extends State<TransactionScreen> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _receiverAccountController =
      TextEditingController();
  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  bool _isSubmitting = false;
  late int _senderAccountNumber;

  @override
  void initState() {
    super.initState();
    _loadSenderAccountNumber();
  }

  Future<void> _loadSenderAccountNumber() async {
    AuthManager authManager = AuthManager();
    try {
      Map<String, dynamic> decodedToken =
          await authManager.decodeJwtToken(context);
      setState(() {
        _senderAccountNumber = int.parse(decodedToken['accNum']);
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Failed to load sender account number.'),
        backgroundColor: Colors.red,
      ));
    }
  }

  Future<void> _createTransaction() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isSubmitting = true;
    });

    final receiverAccountNumber = int.parse(_receiverAccountController.text);
    final amount = double.parse(_amountController.text);
    final description = _descriptionController.text.isNotEmpty
        ? _descriptionController.text
        : null;

    Transaction transaction = Transaction(
      senderAccountNumber: _senderAccountNumber,
      receiverAccountNumber: receiverAccountNumber,
      amount: amount,
      description: description,
    );

    print(transaction.toJson());
    print(transaction.toString());

    final success = await TransactionRepository().transferMoney(transaction);

    setState(() {
      _isSubmitting = false;
    });

    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Transaction created successfully!'),
        backgroundColor: Colors.green,
      ));
      Navigator.pop(context);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text(
            'Failed to create transaction. Account not found or insufficient funds.'),
        backgroundColor: Colors.red,
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Transaction'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: <Widget>[
              TextFormField(
                controller: _receiverAccountController,
                decoration:
                    const InputDecoration(labelText: 'Receiver Account Number'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter receiver account number';
                  }
                  if (_senderAccountNumber == int.parse(value)) {
                    // Compare as int
                    return 'Receiver account number cannot be the same as sender\'s';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _amountController,
                decoration: const InputDecoration(labelText: 'Amount'),
                keyboardType:
                    const TextInputType.numberWithOptions(decimal: true),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter an amount';
                  }
                  if (int.parse(value) == 0) {
                    return 'Please enter a valid amount';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _descriptionController,
                decoration:
                    const InputDecoration(labelText: 'Description (Optional)'),
                keyboardType: TextInputType.text,
                maxLines: 3,
              ),
              const SizedBox(height: 20),
              _isSubmitting
                  ? const Center(child: CircularProgressIndicator())
                  : ElevatedButton(
                      onPressed: _createTransaction,
                      child: const Text('Submit Transaction'),
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
