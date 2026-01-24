import 'package:flutter/material.dart';
import 'package:astra/features/auth/auth_service.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _authService = AuthService();
  bool _isLoading = false;
  String? _errorMessage;
  String? _successMessage;

  void _signup() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
      _successMessage = null;
    });

    final res = await _authService.signup(
      _emailController.text.trim(),
      _passwordController.text,
    );

    if (res['success']) {
      setState(() {
        _successMessage = "Account created! You can now login.";
        _isLoading = false;
      });
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
      appBar: AppBar(backgroundColor: Colors.transparent, elevation: 0),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                "Create Account",
                style: TextStyle(color: Colors.white, fontSize: 28, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),
              Text(
                "Join ASTRA to save your data",
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
              if (_successMessage != null)
                Padding(
                  padding: const EdgeInsets.only(bottom: 20),
                  child: Text(_successMessage!, style: const TextStyle(color: Colors.greenAccent)),
                ),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _signup,
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.blueAccent),
                  child: _isLoading 
                      ? const CircularProgressIndicator(color: Colors.white) 
                      : const Text("Sign Up", style: TextStyle(color: Colors.white, fontSize: 16)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
