import 'package:flutter/material.dart';

class IntroPage2 extends StatelessWidget {
  const IntroPage2({super.key});

  Widget buildCard(IconData icon, String title, String subtitle) {
    return Container(
      padding: const EdgeInsets.all(20),
      margin: const EdgeInsets.symmetric(vertical: 10),
      decoration: BoxDecoration(
        color: const Color(0xFF1A1A1C),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.blueAccent.withOpacity(0.2),
            blurRadius: 10,
          ),
        ],
      ),
      child: Row(
        children: [
          Icon(icon, color: Colors.blueAccent, size: 32),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title,
                    style: const TextStyle(
                        fontSize: 20,
                        color: Colors.white,
                        fontWeight: FontWeight.bold)),
                const SizedBox(height: 6),
                Text(subtitle,
                    style: const TextStyle(
                      color: Colors.white70,
                      fontSize: 15,
                    )),
              ],
            ),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFF0D0D0F),
      padding: const EdgeInsets.symmetric(horizontal: 30),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          buildCard(Icons.chat_bubble_outline, "Chat Astra",
              "Your personal offline-friendly assistant."),
          buildCard(Icons.folder_copy, "Knowledge Base",
              "Upload PDFs and ask questions with citations."),
          buildCard(Icons.build, "Smart Tools",
              "Math Solver • Dictionary • Summary • Emails"),
        ],
      ),
    );
  }
}
