class Transaction {
  final int senderAccountNumber;
  final int receiverAccountNumber;
  final double amount;
  final String? description;

  Transaction({
    required this.senderAccountNumber,
    required this.receiverAccountNumber,
    required this.amount,
    this.description,
  });

  factory Transaction.fromJson(Map<String, dynamic> json) {
    return Transaction(
      senderAccountNumber: json['senderAccountNumber'] ?? 0,
      receiverAccountNumber: json['receiverAccountNumber'] ?? 0,
      amount: json['amount'] ?? 0.0,
      description: json['description'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'senderAccountNumber': senderAccountNumber,
      'receiverAccountNumber': receiverAccountNumber,
      'amount': amount,
      'description': description,
    };
  }
}
