import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:astra/widgets/astra_page.dart';

class EmailScreen extends StatelessWidget {
  const EmailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const AstraPage(
      title: "Email Generator",
      child: EmailBody(),
    );
  }
}

class EmailBody extends StatefulWidget {
  const EmailBody({super.key});

  @override
  State<EmailBody> createState() => _EmailBodyState();
}

class _EmailBodyState extends State<EmailBody> {
  final TextEditingController _controller = TextEditingController();
  String generatedEmail = "";
  bool isLoading = false;

  Future<void> generateEmail() async {
    final text = _controller.text.trim();
    if (text.isEmpty) return;

    setState(() {
      generatedEmail = "";
      isLoading = true;
    });

    try {
      final response = await http.post(
        Uri.parse("http://127.0.0.1:8000/email"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"prompt": text}),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        setState(() {
          generatedEmail = data["email"] ?? "No email generated.";
          isLoading = false;
        });
      } else {
        setState(() {
          generatedEmail = "Error generating email.";
          isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        generatedEmail = "Server connection failed.";
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text("Enter prompt for email:",
            style: TextStyle(color: Colors.white)),
        const SizedBox(height: 8),

        // INPUT FIELD
        TextField(
          controller: _controller,
          maxLines: 3,
          style: const TextStyle(color: Colors.white),
          decoration: const InputDecoration(
            border: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.white24),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.white54),
            ),
            hintText: "Explain what the email is about...",
            hintStyle: TextStyle(color: Colors.white38),
          ),

          onSubmitted: (_) => generateEmail(), // ENTER SUBMISSION
        ),

        const SizedBox(height: 12),

        ElevatedButton(
          onPressed: generateEmail,
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.white,
            foregroundColor: Colors.black,
            padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 12),
          ),
          child: const Text("Generate Email"),
        ),

        const SizedBox(height: 20),
        
        const Text("Generated Email:",
            style: TextStyle(color: Colors.white70, fontSize: 16)),
        const SizedBox(height: 8),

        // OUTPUT AREA
        Expanded(
          child: Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.25),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: Colors.white24),
            ),
            child: SingleChildScrollView(
              child: Text(
                isLoading
                    ? "Generating your email…"
                    : (generatedEmail.isEmpty
                        ? "Your generated email will appear here."
                        : generatedEmail),
                style: const TextStyle(color: Colors.white, fontSize: 15),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
