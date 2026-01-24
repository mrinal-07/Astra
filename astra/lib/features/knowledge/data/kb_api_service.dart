import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;

class KBApiService {
  final String baseUrl;

  KBApiService({this.baseUrl = "http://localhost:8000"});

  /// Uploads a PDF file to the backend.
  Future<Map<String, dynamic>> uploadPdf(File file) async {
    final uri = Uri.parse('$baseUrl/kb/upload');
    final request = http.MultipartRequest('POST', uri);

    // Attach file
    request.files.add(
      await http.MultipartFile.fromPath(
        'file',
        file.path,
      ),
    );

    try {
      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);

      if (response.statusCode == 200) {
        return jsonDecode(response.body) as Map<String, dynamic>;
      } else {
        throw Exception(
          'Upload failed: ${response.statusCode} ${response.body}',
        );
      }
    } catch (e) {
      throw Exception('Error uploading PDF: $e');
    }
  }

  /// Sends a query to the Knowledge Base.
  Future<Map<String, dynamic>> queryKb(String query) async {
    final uri = Uri.parse('$baseUrl/kb/query');

    try {
      final response = await http.post(
        uri,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'query': query}),
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body) as Map<String, dynamic>;
      } else {
        throw Exception(
          'Query failed: ${response.statusCode} ${response.body}',
        );
      }
    } catch (e) {
      throw Exception('Error querying KB: $e');
    }
  }
}
