class AccountBalance {
  final String customerId;
  final double balance;

  AccountBalance({required this.customerId, required this.balance});

  factory AccountBalance.fromJson(Map<String, dynamic> json) {
    return AccountBalance(
      customerId: json['customerId'],
      balance: json['balance'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'customerId': customerId,
      'balance': balance,
    };
  }
}
