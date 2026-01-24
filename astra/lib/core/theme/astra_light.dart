import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AstraLightTheme {
  static ThemeData get theme {
    return ThemeData(
      brightness: Brightness.light,
      useMaterial3: true,
      textTheme: GoogleFonts.poppinsTextTheme(),
      colorScheme: ColorScheme.fromSeed(
        seedColor: Colors.blueAccent,
        brightness: Brightness.light,
      ),
    );
  }
}
