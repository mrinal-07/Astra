import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  static const String baseUrl = 'http://127.0.0.1:8000';
  static const String userKey = 'astra_user_id';
  static const String emailKey = 'astra_user_email';
  static const String nameKey = 'astra_user_name';

  Future<Map<String, dynamic>> signup(String email, String password) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/auth/signup'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'email': email, 'password': password}),
      );

      final data = jsonDecode(response.body);
      if (response.statusCode == 200) {
        return {'success': true, 'user_id': data['user_id'], 'email': data['email']};
      } else {
        return {'success': false, 'message': data['detail'] ?? 'Signup failed'};
      }
    } catch (e) {
      return {'success': false, 'message': 'Network error: $e'};
    }
  }

  Future<Map<String, dynamic>> login(String email, String password) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/auth/login'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'email': email, 'password': password}),
      );

      final data = jsonDecode(response.body);
      if (response.statusCode == 200) {
        await _saveSession(data['user_id'], data['email']);
        return {'success': true, 'user_id': data['user_id'], 'email': data['email']};
      } else {
        return {'success': false, 'message': data['detail'] ?? 'Login failed'};
      }
    } catch (e) {
      return {'success': false, 'message': 'Network error: $e'};
    }
  }

  Future<void> _saveSession(int userId, String email) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(userKey, userId);
    await prefs.setString(emailKey, email);
  }

  static Future<int?> getUserId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt(userKey);
  }

  static Future<String?> getUserEmail() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(emailKey);
  }

  static Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(userKey);
    await prefs.remove(emailKey);
  }

  static Future<bool> isLoggedIn() async {
    final userId = await getUserId();
    return userId != null;
  }

  static Future<void> setUserName(String name) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(nameKey, name);
  }

  static Future<String?> getUserName() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(nameKey);
  }
}
