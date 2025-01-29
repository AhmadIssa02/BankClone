// import 'dart:convert';
// import 'dart:io';

// import 'package:bank_app/Modules/UserModel.dart';
// // import 'package:bank_app/model.dart';
// import 'package:http/http.dart' as http;

// class ApiHandler {
//   final String baseUri = "https://localhost:7280/api/Users";
//   Future<List<User>> getUserData() async {
//     List<User> data = [];
//     final uri = Uri.parse(baseUri);
//     try {
//       final response = await http.get(uri, headers: <String, String>{
//         "Content-Type": "application/json; charset=UTF-8"
//       });
//       if (response.statusCode >= 200 && response.statusCode <= 299) {
//         final List<dynamic> jsonData = jsonDecode(response.body);
//         data = jsonData.map((json) => User.fromJson(json)).toList();
//       }
//       return data;
//     } catch (e) {
//       return data;
//     }
//   }
// }
