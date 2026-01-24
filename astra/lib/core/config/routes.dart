import 'package:flutter/material.dart';
import 'package:astra/features/onboarding/onboarding_screen.dart';
import 'package:astra/features/chat/chat_screen.dart';
import 'package:astra/features/settings/settings_screen.dart';
import 'package:astra/features/math/math_screen.dart';
import 'package:astra/features/dictionary/dictionary_screen.dart';
import 'package:astra/features/summarizer/summarizer_screen.dart';
import 'package:astra/features/email/email_screen.dart';
import 'package:astra/features/todo/todo_screen.dart';
import 'package:astra/features/knowledge/presentation/kb_screen.dart';

class AppRoutes {
  static const onboarding = '/';
  static const chat = '/chat';
  static const settings = '/settings';

  static const math = '/math';
  static const dictionary = '/dictionary';
  static const summarizer = '/summarizer';
  static const email = '/email';
  static const todo = '/todo';
  static const knowledge = '/knowledge';

  static Map<String, WidgetBuilder> routes = {
    onboarding: (_) => const OnboardingScreen(),
    chat: (_) => const ChatScreen(),
    settings: (_) => const SettingsScreen(),
    math: (_) => const MathScreen(),
    dictionary: (_) => const DictionaryScreen(),
    summarizer: (_) => const SummarizerScreen(),
    email: (_) => const EmailScreen(),
    todo: (_) => const TodoScreen(),
    knowledge: (_) => const KBScreen(),
  };
}
