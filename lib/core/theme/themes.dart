import 'package:flutter/material.dart';

class AppTheme {
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,

      scaffoldBackgroundColor: const Color(0xFFF9F9F9),

      colorScheme: ColorScheme.light(
        primary: const Color(0xFF7E0092),
        secondary: const Color(0xFF006A60),
        tertiary: const Color(0xFF5D4400),
      ),

      textTheme: const TextTheme(
        headlineLarge: TextStyle(
          fontFamily: 'Manrope',
          fontWeight: FontWeight.w600,
          letterSpacing: -0.5,
        ),
        bodyLarge: TextStyle(fontFamily: 'Inter', fontWeight: FontWeight.w400),
      ),
    );
  }
}
