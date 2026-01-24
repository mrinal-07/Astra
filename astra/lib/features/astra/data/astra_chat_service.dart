import 'dart:convert';
import 'package:http/http.dart' as http;

class AstraChatService {
  final String baseUrl;

  AstraChatService({this.baseUrl = 'http://127.0.0.1:8000'});

  /// Sends a message to the ASTRA helper bot and returns the response text.
  Future<String> sendMessage(String message) async {
    final trimmedMessage = message.trim();
    if (trimmedMessage.isEmpty) {
      return "Please enter a message.";
    }

    try {
      final response = await http.post(
        Uri.parse('$baseUrl/astra/chat'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'message': trimmedMessage}),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data['response'] ?? "I'm sorry, I couldn't process that.";
      } else {
        return "Error: Server returned status code ${response.statusCode}";
      }
    } catch (e) {
      return "Network error: $e";
    }
  }
}
