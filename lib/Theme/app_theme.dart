import 'package:flutter/material.dart';

class AppTheme {
  static const Color primaryColor = Color(0xFF0A73FF);
  static const Color secondaryColor = Color(0xFF1C1C1E);
  static const Color accentColor = Color(0xFFFFC107);
  static const String fontFamily = 'Roboto';

  static ThemeData get lightTheme {
    return ThemeData(
      brightness: Brightness.light,
      primaryColor: primaryColor,
      scaffoldBackgroundColor: const Color(0xFFF5F6FA),
      fontFamily: fontFamily,
      colorScheme: const ColorScheme.light(
        primary: primaryColor,
        secondary: accentColor,
      ),
      appBarTheme: const AppBarTheme(
        elevation: 4,
        backgroundColor: primaryColor,
        foregroundColor: Colors.white,
        centerTitle: true,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryColor,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(12)),
          ),
          textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  static ThemeData get darkTheme {
    return ThemeData(
      brightness: Brightness.dark,
      primaryColor: primaryColor,
      scaffoldBackgroundColor: const Color(0xFF121212),
      fontFamily: fontFamily,
      colorScheme: const ColorScheme.dark(
        primary: primaryColor,
        secondary: accentColor,
      ),
      appBarTheme: const AppBarTheme(
        elevation: 4,
        backgroundColor: secondaryColor,
        foregroundColor: Colors.white,
        centerTitle: true,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryColor,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(12)),
          ),
          textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
