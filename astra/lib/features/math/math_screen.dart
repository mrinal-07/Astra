import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:astra/widgets/astra_page.dart';

class MathScreen extends StatelessWidget {
  const MathScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const AstraPage(
      title: "Math Solver",
      child: MathBody(),
    );
  }
}

class MathBody extends StatefulWidget {
  const MathBody({super.key});

  @override
  State<MathBody> createState() => _MathBodyState();
}

class _MathBodyState extends State<MathBody> {
  final TextEditingController _controller = TextEditingController();
  String result = "";

  Future<void> solve() async {
    final expr = _controller.text.trim();
    if (expr.isEmpty) return;

    final response = await http.post(
      Uri.parse("http://127.0.0.1:8000/solve_math"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({"expression": expr}),
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      setState(() => result = data["result"].toString());
    } else {
      setState(() => result = "Error");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text("Enter expression:", style: TextStyle(color: Colors.white)),
        const SizedBox(height: 8),

        TextField(
          controller: _controller,
          style: const TextStyle(color: Colors.white),
          decoration: const InputDecoration(
            hintText: "(2+3)*5",
            border: OutlineInputBorder(),
            hintStyle: TextStyle(color: Colors.white38),
          ),
        ),

        const SizedBox(height: 12),
        ElevatedButton(onPressed: solve, child: const Text("Solve")),

        const SizedBox(height: 20),
        Text(
          result.isEmpty ? "Result will appear here." : result,
          style: const TextStyle(color: Colors.white, fontSize: 18),
        ),
      ],
    );
  }
}
