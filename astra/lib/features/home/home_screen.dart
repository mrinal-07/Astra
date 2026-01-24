import 'package:flutter/material.dart';
import 'package:astra/features/chat/chat_screen.dart';
import 'package:astra/features/knowledge/presentation/kb_screen.dart';
import 'package:astra/features/dictionary/dictionary_screen.dart';
import 'package:astra/features/math/math_screen.dart';
import 'package:astra/features/summarizer/summarizer_screen.dart';
import 'package:astra/features/email/email_screen.dart';
import 'package:astra/features/todo/todo_screen.dart';
import 'package:astra/features/settings/settings_screen.dart';
import 'package:astra/features/home/astra_guide_screen.dart';
import 'package:astra/features/auth/auth_service.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String _userName = "...";

  @override
  void initState() {
    super.initState();
    _loadUserName();
  }

  Future<void> _loadUserName() async {
    final name = await AuthService.getUserName();
    if (mounted) {
      setState(() {
        _userName = name ?? "User";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final tools = [
      _Tool("Chat with Astra", "assets/images/chat.png", const ChatScreen()),
      _Tool("Knowledge Base", "assets/images/knowledge.png", const KBScreen()),
      _Tool("Dictionary", "assets/images/dictionary.png", const DictionaryScreen()),
      _Tool("Math Solver", "assets/images/math.png", const MathScreen()),
      _Tool("Summarizer", "assets/images/summarize.png", const SummarizerScreen()),
      _Tool("Email Writer", "assets/images/email.png", const EmailScreen()),
      _Tool("Todo List", "assets/images/todo.png", const TodoScreen()),
      _Tool("Settings", "assets/images/settings.png", const SettingsScreen()),
      _Tool(
        "Astra Guide",
        "",
        const AstraGuideScreen(),
        subtitle: "How to use Astra",
        icon: Icons.menu_book_rounded,
      ),
    ];

    return Scaffold(
      backgroundColor: const Color(0xFF0D0D0F),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        // Authentication entry points removed as per requirements.
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Text(
                "Welcome, $_userName 👋",
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                "Your Astra tools, all in one place.",
                style: TextStyle(
                  color: Colors.white.withOpacity(0.6),
                  fontSize: 16,
                ),
              ),

              const SizedBox(height: 30),

              // Tools Grid
              Expanded(
                child: GridView.builder(
                  itemCount: tools.length,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 4,
                    childAspectRatio: 1,
                    crossAxisSpacing: 14,
                    mainAxisSpacing: 14,
                  ),
                  itemBuilder: (context, index) {
                    final tool = tools[index];
                    return _ToolCard(tool: tool);
                  },
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class _Tool {
  final String title;
  final String imagePath;
  final Widget screen;
  final String? subtitle;
  final IconData? icon;

  _Tool(this.title, this.imagePath, this.screen, {this.subtitle, this.icon});
}

class _ToolCard extends StatelessWidget {
  final _Tool tool;
  const _ToolCard({required this.tool});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(context,
          MaterialPageRoute(builder: (_) => tool.screen),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(18),
          gradient: const LinearGradient(
            colors: [
              Color(0xFF1A1A1C),
              Color(0xFF131315),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF4F8CFF).withOpacity(0.15),
              blurRadius: 10,
              spreadRadius: 1,
            )
          ],
        ),
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Icon(tool.icon, size: 26, color: Colors.white),
            Expanded(
              child: Center(
                child: tool.imagePath.isNotEmpty
                    ? Image.asset(
                        tool.imagePath,
                        fit: BoxFit.contain,
                      )
                    : Container(
                        width: 56,
                        height: 56,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white.withOpacity(0.08),
                        ),
                        child: Icon(
                          tool.icon ?? Icons.help_outline,
                          size: 28,
                          color: Colors.white.withOpacity(0.85),
                        ),
                      ),
              ),
            ),

            const SizedBox(height: 10),
            Text(
              tool.title,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 14,
                fontWeight: FontWeight.bold,
                height: 1.2,
              ),
            ),
            if (tool.subtitle != null)
              Text(
                tool.subtitle!,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: Colors.white.withOpacity(0.5),
                  fontSize: 10,
                  height: 1.2,
                ),
              ),
          ],
        ),
      ),
    );
  }
}
