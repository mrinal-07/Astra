import 'dart:ui';
import 'package:flutter/material.dart';

class GlassInputBar extends StatefulWidget {
  final Function(String) onSend;

  const GlassInputBar({super.key, required this.onSend});

  @override
  State<GlassInputBar> createState() => _GlassInputBarState();
}

class _GlassInputBarState extends State<GlassInputBar> {
  final TextEditingController controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(12, 10, 12, 20),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.05),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: Colors.white.withOpacity(0.1),
              ),
            ),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: controller,
                    style: const TextStyle(color: Colors.white),
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                      hintText: "Message Astra...",
                      hintStyle: TextStyle(color: Colors.white54),
                    ),

                    // 🔥 PRESS ENTER TO SEND
                    onSubmitted: (value) {
                      if (value.trim().isNotEmpty) {
                        widget.onSend(value);
                        controller.clear();
                      }
                    },
                  ),
                ),

                IconButton(
                  icon: const Icon(Icons.send, color: Color(0xFF4F8CFF)),
                  onPressed: () {
                    widget.onSend(controller.text);
                    controller.clear();
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
