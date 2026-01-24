import 'package:flutter/material.dart';

class TypingIndicator extends StatefulWidget {
  const TypingIndicator({super.key});

  @override
  State<TypingIndicator> createState() => _TypingIndicatorState();
}

class _TypingIndicatorState extends State<TypingIndicator>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 60,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: List.generate(3, (i) {
          return AnimatedBuilder(
            animation: _controller,
            builder: (_, __) {
              double opacity = (0.3 +
                  0.7 *
                      (1 -
                          ((i * 0.3 +
                                      _controller.value) %
                                  1)
                              .abs()));
              return Container(
                margin: const EdgeInsets.symmetric(horizontal: 3),
                width: 10,
                height: 10,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(opacity),
                  shape: BoxShape.circle,
                ),
              );
            },
          );
        }),
      ),
    );
  }
}
