import 'package:flutter/material.dart';

class AstraGuideScreen extends StatelessWidget {
  const AstraGuideScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0D0D0F),
      appBar: AppBar(
        title: const Text("Astra Guide"),
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "How to use Astra",
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              "Astra is your all-in-one productivity suite. Here is a quick guide on how to get the most out of it.",
              style: TextStyle(
                color: Colors.white.withOpacity(0.7),
                fontSize: 16,
                height: 1.5,
              ),
            ),
            const SizedBox(height: 32),
            _buildGuideSection(
              title: "Chat with Astra",
              icon: Icons.chat_bubble_outline_rounded,
              description:
                  "Ask general questions, get help with Astra's features, or just have a conversation. This is your main assistant.",
            ),
            _buildGuideSection(
              title: "Knowledge Base",
              icon: Icons.library_books_outlined,
              description:
                  "Upload PDF documents and ask questions about them. Astra will retrieve relevant parts and provide cited answers.",
            ),
            _buildGuideSection(
              title: "Math Solver",
              icon: Icons.calculate_outlined,
              description:
                  "Enter mathematical expressions or equations to get instant, accurate solutions.",
            ),
            _buildGuideSection(
              title: "Summarizer",
              icon: Icons.short_text_rounded,
              description:
                  "Paste long articles or texts to get a concise summary in seconds.",
            ),
            _buildGuideSection(
              title: "Email Writer",
              icon: Icons.email_outlined,
              description:
                  "Tell Astra what you want to say, and it will draft a professional email for you.",
            ),
            _buildGuideSection(
              title: "Dictionary",
              icon: Icons.menu_book_rounded,
              description:
                  "Look up definitions, synonyms, and phonetics for any word.",
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGuideSection({
    required String title,
    required IconData icon,
    required String description,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 24),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.05),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: Colors.blueAccent, size: 24),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  description,
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.6),
                    fontSize: 14,
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
