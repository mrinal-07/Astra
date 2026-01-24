import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:astra/features/onboarding/onboarding_screen.dart';
import 'package:astra/features/home/home_screen.dart'; 
import 'package:astra/features/home/home_screen.dart';
import 'package:astra/features/auth/login_screen.dart';
import 'package:astra/features/auth/auth_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Astra',
      theme: ThemeData(
        fontFamily: 'Inter',
        primaryColor: const Color(0xFF4F8CFF),
      ),
      home: const OnboardingScreen(),
    );
  }
}
