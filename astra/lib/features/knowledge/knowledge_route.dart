import 'package:flutter/material.dart';
import 'presentation/kb_screen.dart';

class KnowledgeRoute {
  static const String routeName = '/knowledge_v2';

  static Route<dynamic> route() {
    return MaterialPageRoute(
      builder: (_) => const KBScreen(),
      settings: const RouteSettings(name: routeName),
    );
  }
}
