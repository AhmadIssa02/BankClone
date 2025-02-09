import 'package:bank_app/Modules/Auth/auth_manager.dart';
import 'package:bank_app/Screens/landing_screen.dart';
import 'package:bank_app/Screens/main_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class AppColors {
  static const Color tertiary = Color(0xFFD30132); // #d30132
  static const Color secondary = Color.fromARGB(255, 103, 153, 199); // #5288aa
  static const Color primary = Color(0xFF233645); // #233645
  static const Color white = Colors.white;
  static const Color black = Colors.black;
  static const Color canvas = Color(0xFFF3F4F9);
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load();
  final String? encryptionKey = dotenv.env['ENCRYPTION_KEY'];
  if (encryptionKey == null) {
    throw Exception("Invalid encryption key!");
  }
  AuthManager authManager = AuthManager();
  await authManager.saveEncryptionKey(encryptionKey);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Bank App',
      theme: ThemeData(
        primaryColor: AppColors.primary,
        indicatorColor: AppColors.secondary,
        cardColor: AppColors.tertiary,
        canvasColor: AppColors.canvas,
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primary,
            foregroundColor: AppColors.white,
          ),
        ),
        textTheme: const TextTheme(
          bodyLarge: TextStyle(color: AppColors.black),
          bodyMedium: TextStyle(color: AppColors.white),
          titleLarge: TextStyle(
            fontWeight: FontWeight.bold,
            color: AppColors.primary,
            fontSize: 22,
          ),
        ),
        cardTheme: CardTheme(
          color: AppColors.primary,
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          elevation: 4,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        useMaterial3: true,
      ),
      debugShowCheckedModeBanner: false,
      home: const MainScreen(),
    );
  }
}
