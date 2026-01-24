import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:astra/widgets/astra_page.dart';

class DictionaryScreen extends StatelessWidget {
  const DictionaryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const AstraPage(
      title: "Dictionary",
      child: DictionaryBody(),
    );
  }
}

class DictionaryBody extends StatefulWidget {
  const DictionaryBody({super.key});

  @override
  State<DictionaryBody> createState() => _DictionaryBodyState();
}

class _DictionaryBodyState extends State<DictionaryBody> {
  final TextEditingController _controller = TextEditingController();
  String _definition = "";
  final FocusNode _fieldFocusNode = FocusNode();

  @override
  void dispose() {
    _controller.dispose();
    _fieldFocusNode.dispose();
    super.dispose();
  }

  Future<void> lookup() async {
    final word = _controller.text.trim();
    if (word.isEmpty) return;

    setState(() {
      _definition = "";
    });
    setState(() {
      _definition = "Looking up...";
    });

    final response = await http.get(
      Uri.parse("http://127.0.0.1:8000/dictionary/$word"),
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      setState(() => _definition = data["meaning"] ?? "");
    } else {
      setState(() => _definition = "Not found.");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text("Enter a word:", style: TextStyle(color: Colors.white)),
        const SizedBox(height: 8),

        RawKeyboardListener(
          focusNode: _fieldFocusNode,
          onKey: (event) {
            if (event is RawKeyDownEvent &&
                event.logicalKey == LogicalKeyboardKey.enter &&
                !(event.isShiftPressed)) {
              lookup();
            }
          },
          child: TextField(
            controller: _controller,
            decoration: const InputDecoration(
              border: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.white24),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.white54),
              ),
              hintText: "algorithm",
              hintStyle: TextStyle(color: Colors.white38),
            ),
            style: const TextStyle(color: Colors.white),
            onSubmitted: (_) => lookup(),
          ),
        ),

        const SizedBox(height: 12),
        ElevatedButton(
          onPressed: lookup,
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.white,
            foregroundColor: Colors.black,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          ),
          child: const Text("Lookup"),
        ),

        const SizedBox(height: 20),
        Text(
          _definition.isEmpty ? "Meaning will appear here." : _definition,
          style: const TextStyle(color: Colors.white, fontSize: 16),
        ),
      ],
    );
  }
}
