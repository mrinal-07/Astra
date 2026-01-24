import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class AstraChatTest extends StatefulWidget {
  const AstraChatTest({super.key});

  @override
  State<AstraChatTest> createState() => _AstraChatTestState();
}

class _AstraChatTestState extends State<AstraChatTest> {
  final TextEditingController _controller = TextEditingController();
  String _response = "";
  bool _loading = false;

  Future<void> sendMessage() async {
    final msg = _controller.text.trim();
    if (msg.isEmpty) return;

    setState(() {
      _loading = true;
      _response = "";
    });

    try {
      final res = await http.post(
        Uri.parse("http://127.0.0.1:8000/astra/chat"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"message": msg}),
      );

      final data = jsonDecode(res.body);
      setState(() {
        _response = data["response"] ?? "No response";
        _loading = false;
      });
    } catch (e) {
      setState(() {
        _response = "Error: $e";
        _loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("ASTRA Chat Test")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: _controller,
              decoration: const InputDecoration(
                labelText: "Type a message",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: _loading ? null : sendMessage,
              child: Text(_loading ? "Thinking..." : "Send"),
            ),
            const SizedBox(height: 24),
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                _response,
                style: const TextStyle(fontSize: 16),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
