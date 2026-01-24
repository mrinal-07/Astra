import 'package:flutter/material.dart';

class MessageBubble extends StatelessWidget {
  final String text;
  final bool isUser;

  const MessageBubble({
    super.key,
    required this.text,
    required this.isUser,
  });

  @override
  Widget build(BuildContext context) {
    // Handle empty/streaming text gracefully
    final displayText = text.isEmpty ? "..." : text;

    return Row(
      mainAxisAlignment:
          isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Astra avatar (only for AI messages)
        if (!isUser)
          Container(
            width: 38,
            height: 38,
            margin: const EdgeInsets.only(right: 8),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: const LinearGradient(
                colors: [
                  Color(0xFF4F8CFF),
                  Color(0xFF7A5CFF),
                ],
              ),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF4F8CFF).withOpacity(0.4),
                  blurRadius: 12,
                  spreadRadius: 1,
                )
              ],
            ),
            child: const Center(
              child: Icon(
                Icons.auto_awesome,
                color: Colors.white,
                size: 20,
              ),
            ),
          ),

        // Bubble
        Flexible(
          child: Container(
            margin: const EdgeInsets.symmetric(vertical: 6),
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            decoration: BoxDecoration(
              color: isUser
                  ? const Color(0xFF4F8CFF)
                  : const Color(0xFF1A1A1C),
              borderRadius: BorderRadius.circular(14),
              boxShadow: isUser
                  ? [
                      BoxShadow(
                        color: const Color(0xFF4F8CFF).withOpacity(0.3),
                        blurRadius: 10,
                        spreadRadius: 1,
                      )
                    ]
                  : [],
            ),
            child: Text(
              displayText,
              style: TextStyle(
                color: isUser
                    ? Colors.white
                    : Colors.white.withOpacity(0.85),
                fontSize: 15,
                height: 1.3,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
