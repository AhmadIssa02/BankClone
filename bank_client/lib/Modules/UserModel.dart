class User {
  final int userId;
  final String name;
  final String address;

  const User({
    required this.userId,
    required this.name,
    required this.address,
  });

  factory User.fromJson(Map<String, dynamic> json) => User(
        userId: json["userId"],
        name: json["name"],
        address: json["address"],
      );
  Map<String, dynamic> toJson() => {
        "userId": userId,
        "name": name,
        "address": address,
      };
}
