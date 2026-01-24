import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:astra/widgets/astra_page.dart';

class SummarizerScreen extends StatelessWidget {
  const SummarizerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const AstraPage(
      title: "Summarizer",
      child: SummarizerBody(),
    );
  }
}

class SummarizerBody extends StatefulWidget {
  const SummarizerBody({super.key});

  @override
  State<SummarizerBody> createState() => _SummarizerBodyState();
}

class _SummarizerBodyState extends State<SummarizerBody> {
  final TextEditingController _controller = TextEditingController();
  final FocusNode _fieldFocusNode = FocusNode();
  String summary = "";
  bool isLoading = false;

  @override
  void dispose() {
    _fieldFocusNode.dispose();
    _controller.dispose();
    super.dispose();
  }

  Future<void> summarize() async {
    final text = _controller.text.trim();
    if (text.isEmpty) return;

    setState(() {
      summary = "";
      isLoading = true;
    });

    final response = await http.post(
      Uri.parse("http://127.0.0.1:8000/summarize"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({"text": text}),
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      setState(() {
        summary = data["summary"] ?? "";
        isLoading = false;
      });
    } else {
      setState(() {
        summary = "Error";
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text("Paste text:", style: TextStyle(color: Colors.white)),
        const SizedBox(height: 8),

        RawKeyboardListener(
          focusNode: _fieldFocusNode,
          onKey: (event) {
            if (event is RawKeyDownEvent &&
                event.logicalKey == LogicalKeyboardKey.enter &&
                !(event.isShiftPressed)) {
              // Remove stray newline if present
              if (_controller.text.endsWith('\n')) {
                _controller.text =
                    _controller.text.substring(0, _controller.text.length - 1);
                _controller.selection = TextSelection.fromPosition(
                    TextPosition(offset: _controller.text.length));
              }
              summarize();
            }
          },
          child: TextField(
            controller: _controller,
            maxLines: 5,
            style: const TextStyle(color: Colors.white),
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              hintText: "Enter text to summarize...",
              hintStyle: TextStyle(color: Colors.white38),
            ),
          ),
        ),

        const SizedBox(height: 12),
        ElevatedButton(onPressed: summarize, child: const Text("Summarize")),

        const SizedBox(height: 20),
        Text(
          isLoading
              ? "Generating summary…"
              : (summary.isEmpty ? "Summary will appear here." : summary),
          style: const TextStyle(color: Colors.white, fontSize: 16),
        ),
      ],
    );
  }
}
