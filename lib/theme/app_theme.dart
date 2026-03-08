import 'package:flutter/material.dart';

class AppTheme {
  static const Color backgroundBlack = Color(0xFF0A0A0A);
  static const Color neonBlue = Color(0xFF00F0FF);
  static const Color neonPurple = Color(0xFFB026FF);
  static const Color textWhite = Color(0xFFFFFFFF);
  static const Color textGrey = Color(0xFFB0B0B0);

  static ThemeData get darkTheme {
    return ThemeData(
      brightness: Brightness.dark,
      scaffoldBackgroundColor: backgroundBlack,
      primaryColor: neonBlue,
      colorScheme: const ColorScheme.dark(
        primary: neonBlue,
        secondary: neonPurple,
        surface: backgroundBlack,
      ),
      fontFamily: 'Inter', // Assuming Inter or similar standard web font for now
      textTheme: const TextTheme(
        headlineLarge: TextStyle(
          color: textWhite,
          fontSize: 32,
          fontWeight: FontWeight.w800,
          letterSpacing: -0.5,
        ),
        bodyLarge: TextStyle(
          color: textWhite,
          fontSize: 22,
          fontWeight: FontWeight.w500,
          height: 1.4,
        ),
        bodyMedium: TextStyle(
          color: textGrey,
          fontSize: 18,
          fontWeight: FontWeight.w400,
          height: 1.5,
        ),
      ),
    );
  }
}
