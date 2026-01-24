import 'package:flutter/material.dart';
import 'package:astra/widgets/astra_drawer.dart';
import 'package:astra/widgets/astra_appbar.dart';

class AstraPage extends StatelessWidget {
  final String title;
  final Widget child;
  final EdgeInsets padding;

  const AstraPage({
    super.key,
    required this.title,
    required this.child,
    this.padding = const EdgeInsets.all(24.0),
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const AstraDrawer(),
      backgroundColor: const Color(0xFF0D0D0F),

      appBar: AstraAppBar(title: title),

      body: Padding(
        padding: padding,
        child: child,
      ),
    );
  }
}

