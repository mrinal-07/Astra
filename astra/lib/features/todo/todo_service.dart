import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:astra/features/auth/auth_service.dart';

class TodoService {
  static const String baseUrl = 'http://127.0.0.1:8000/todo';

  Future<List<Map<String, dynamic>>> fetchTodos() async {
    final userId = await AuthService.getUserId();
    if (userId == null) return [];

    try {
      final response = await http.get(Uri.parse('$baseUrl/list?user_id=$userId'));
      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        return data.map((e) => e as Map<String, dynamic>).toList();
      }
      return [];
    } catch (e) {
      return [];
    }
  }

  Future<Map<String, dynamic>?> addTodo(String task) async {
    final userId = await AuthService.getUserId();
    if (userId == null) return null;

    try {
      final response = await http.post(
        Uri.parse('$baseUrl/add'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'user_id': userId, 'task': task}),
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  Future<bool> deleteTodo(int todoId) async {
    try {
      final response = await http.delete(Uri.parse('$baseUrl/delete?todo_id=$todoId'));
      return response.statusCode == 200;
    } catch (e) {
      return false;
    }
  }
}
