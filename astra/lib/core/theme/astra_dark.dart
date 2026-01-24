import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AstraDarkTheme {
  static ThemeData get theme {
    return ThemeData(
      brightness: Brightness.dark,
      useMaterial3: true,

      scaffoldBackgroundColor: const Color(0xFF0D0D0F), // deep charcoal

      textTheme: GoogleFonts.interTextTheme(
        const TextTheme(
          bodyMedium: TextStyle(color: Colors.white70),
          bodyLarge: TextStyle(color: Colors.white),
        ),
      ),

      colorScheme: const ColorScheme.dark(
        primary: Color(0xFF4F8CFF),   // neon blue
        secondary: Color(0xFF7A5CFF), // neon purple
        surface: Color(0xFF1A1A1C), 
      ),

      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: Colors.white,
        ),
      ),
    );
  }
}
