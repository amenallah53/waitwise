import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

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

      textTheme: TextTheme(
        headlineLarge: TextStyle(
          //fontFamily: 'Manrope',
          fontFamily: GoogleFonts.manrope().fontFamily,
          fontWeight: FontWeight.w600,
          //letterSpacing: -0.5,
        ),
        headlineMedium: TextStyle(
          fontFamily: GoogleFonts.manrope().fontFamily,
          fontWeight: FontWeight.w400,
          //letterSpacing: -0.5,
        ),
        bodyLarge: TextStyle(
          fontFamily: GoogleFonts.inter().fontFamily,
          fontWeight: FontWeight.w400,
        ),
      ),
    );
  }
}
