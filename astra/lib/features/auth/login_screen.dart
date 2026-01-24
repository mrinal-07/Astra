import 'package:flutter/material.dart';
import 'package:astra/features/auth/auth_service.dart';
import 'package:astra/features/auth/signup_screen.dart';
import 'package:astra/features/home/home_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _authService = AuthService();
  bool _isLoading = false;
  String? _errorMessage;

  void _login() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    final res = await _authService.login(
      _emailController.text.trim(),
      _passwordController.text,
    );

    if (res['success']) {
      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const HomeScreen()),
        );
      }
    } else {
      setState(() {
        _errorMessage = res['message'];
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0D0D0F),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                "Welcome to ASTRA",
                style: TextStyle(color: Colors.white, fontSize: 28, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),
              Text(
                "Login to your account",
                style: TextStyle(color: Colors.white.withOpacity(0.6), fontSize: 16),
              ),
              const SizedBox(height: 48),
              TextField(
                controller: _emailController,
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  labelText: "Email",
                  labelStyle: const TextStyle(color: Colors.white60),
                  enabledBorder: OutlineInputBorder(borderSide: const BorderSide(color: Colors.white24)),
                  focusedBorder: const OutlineInputBorder(borderSide: BorderSide(color: Colors.blueAccent)),
                ),
              ),
              const SizedBox(height: 20),
              TextField(
                controller: _passwordController,
                obscureText: true,
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  labelText: "Password",
                  labelStyle: const TextStyle(color: Colors.white60),
                  enabledBorder: OutlineInputBorder(borderSide: const BorderSide(color: Colors.white24)),
                  focusedBorder: const OutlineInputBorder(borderSide: BorderSide(color: Colors.blueAccent)),
                ),
              ),
              const SizedBox(height: 40),
              if (_errorMessage != null)
                Padding(
                  padding: const EdgeInsets.only(bottom: 20),
                  child: Text(_errorMessage!, style: const TextStyle(color: Colors.redAccent)),
                ),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _login,
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.blueAccent),
                  child: _isLoading 
                      ? const CircularProgressIndicator(color: Colors.white) 
                      : const Text("Login", style: TextStyle(color: Colors.white, fontSize: 16)),
                ),
              ),
              const SizedBox(height: 24),
              TextButton(
                onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const SignupScreen())),
                child: const Text("Don't have an account? Sign up", style: TextStyle(color: Colors.blueAccent)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
