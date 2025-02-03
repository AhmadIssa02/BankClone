import 'package:bank_app/Screens/landing_screen.dart';
import 'package:bank_app/Screens/login_screen.dart';
import 'package:bank_app/Screens/main_screen.dart';
import 'package:bank_app/Screens/register_screen.dart';
import 'package:bank_app/Screens/settings.dart';
import 'package:flutter/material.dart';

class AppColors {
  static const Color tertiary = Color(0xFFD30132); // Ternary color: #d30132
  static const Color secondary =
      Color.fromARGB(255, 103, 153, 199); // Secondary color: #5288aa
  static const Color primary = Color(0xFF233645); // Primary color: #233645
  static const Color white = Colors.white;
  static const Color black = Colors.black;
  static const Color canvas = Color(0xFFF3F4F9);
}

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
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
          margin: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 8,
          ),
          elevation: 4,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        useMaterial3: true,
      ),
      debugShowCheckedModeBanner: false,
      home: const LandingScreen(),
    );
  }
}
