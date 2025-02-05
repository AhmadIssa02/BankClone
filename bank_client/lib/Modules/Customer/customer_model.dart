class Customer {
  String email;
  String firstName;
  String lastName;
  String iban;
  int accountNumber;
  DateTime dateCreated;

  Customer({
    required this.email,
    required this.firstName,
    required this.lastName,
    required this.iban,
    required this.accountNumber,
    required this.dateCreated,
  });

  factory Customer.fromJson(Map<String, dynamic> json) {
    return Customer(
      email: json['email'],
      firstName: json['firstName'],
      lastName: json['lastName'],
      iban: json['iban'],
      accountNumber: json['accountNumber'],
      dateCreated: DateTime.parse(json['dateCreated']),
    );
  }
}
