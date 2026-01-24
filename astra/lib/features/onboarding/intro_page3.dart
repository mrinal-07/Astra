import 'package:flutter/material.dart';
import 'package:astra/features/auth/auth_service.dart';
import 'package:astra/features/home/home_screen.dart';

class IntroPage3 extends StatefulWidget {
  const IntroPage3({super.key});

  @override
  State<IntroPage3> createState() => _IntroPage3State();
}

class _IntroPage3State extends State<IntroPage3> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final AuthService _authService = AuthService();

  bool _isLogin = true;
  bool _isLoading = false;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadSavedName();
  }

  Future<void> _loadSavedName() async {
    final name = await AuthService.getUserName();
    if (name != null) {
      setState(() => _nameController.text = name);
    }
  }

  void _toggleMode() {
    setState(() {
      _isLogin = !_isLogin;
      _error = null;
    });
  }

  Future<void> _handleAuth() async {
    final name = _nameController.text.trim();
    final email = _emailController.text.trim();
    final password = _passwordController.text;

    if (email.isEmpty || password.isEmpty || (!_isLogin && name.isEmpty)) {
      setState(() => _error = "Please fill all fields");
      return;
    }

    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final Map<String, dynamic> result;
      if (_isLogin) {
        result = await _authService.login(email, password);
      } else {
        result = await _authService.signup(email, password);
      }

      if (result['success']) {
        if (!_isLogin) {
          await AuthService.setUserName(name);
        }
        if (mounted) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (_) => const HomeScreen()),
          );
        }
      } else {
        setState(() => _error = result['message']);
      }
    } catch (e) {
      setState(() => _error = "An error occurred. Please try again.");
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFF0D0D0F),
      padding: const EdgeInsets.symmetric(horizontal: 30),
      child: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                _isLogin ? "Welcome Back" : "One Last Step",
                style: const TextStyle(
                    fontSize: 32, color: Colors.white, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 10),
              Text(
                _isLogin 
                    ? "Log in to access your Astra" 
                    : "Create an account to get started",
                style: TextStyle(color: Colors.white.withOpacity(0.6), fontSize: 16),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 40),
              
              if (!_isLogin) ...[
                _buildField(_nameController, "Your Name", Icons.person_outline),
                const SizedBox(height: 16),
              ],
              
              _buildField(_emailController, "Email", Icons.email_outlined),
              const SizedBox(height: 16),
              _buildField(_passwordController, "Password", Icons.lock_outline, isPassword: true),
              
              if (_error != null) ...[
                const SizedBox(height: 20),
                Text(_error!, style: const TextStyle(color: Colors.redAccent, fontSize: 14)),
              ],
              
              const SizedBox(height: 40),
              
              SizedBox(
                width: double.infinity,
                height: 55,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _handleAuth,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF4F8CFF),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                  ),
                  child: _isLoading 
                      ? const SizedBox(
                          height: 20, 
                          width: 20, 
                          child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2)
                        ) 
                      : Text(
                          _isLogin ? "Login" : "Register",
                          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                ),
              ),
              
              const SizedBox(height: 20),
              
              TextButton(
                onPressed: _isLoading ? null : _toggleMode,
                child: Text(
                  _isLogin 
                      ? "Don't have an account? Sign Up" 
                      : "Already have an account? Login",
                  style: TextStyle(color: Colors.white.withOpacity(0.7)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildField(TextEditingController controller, String hint, IconData icon, {bool isPassword = false}) {
    return TextField(
      controller: controller,
      obscureText: isPassword,
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: const TextStyle(color: Colors.white38),
        prefixIcon: Icon(icon, color: Colors.white38),
        filled: true,
        fillColor: const Color(0xFF1A1A1C),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }
}
