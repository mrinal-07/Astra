import 'package:flutter/material.dart';
import 'package:astra/core/config/routes.dart';

class AstraDrawer extends StatelessWidget {
  const AstraDrawer({super.key});

  Widget _navItem({
  required BuildContext context,
  required IconData icon,
  required String label,
  required String route,
}) {
  return ListTile(
    leading: Icon(icon, color: Colors.white70, size: 22),
    title: Text(
      label,
      style: const TextStyle(color: Colors.white, fontSize: 14),
    ),
    onTap: () {
      Navigator.pop(context);               // Close drawer
      Navigator.pushNamed(context, route);  // FIXED navigation
    },
  );
}


  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: const Color(0xFF111116),
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const DrawerHeader(
              margin: EdgeInsets.zero,
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "ASTRA",
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 4,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    "Offline AI Assistant",
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
            ),

            _navItem(
              context: context,
              icon: Icons.chat_bubble_outline,
              label: "Chat with Astra",
              route: AppRoutes.chat,
            ),

            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Text(
                "Tools",
                style: TextStyle(
                  color: Colors.white54,
                  fontSize: 12,
                  letterSpacing: 1,
                ),
              ),
            ),

            _navItem(
              context: context,
              icon: Icons.calculate_outlined,
              label: "Math Solver",
              route: AppRoutes.math,
            ),
            _navItem(
              context: context,
              icon: Icons.menu_book_outlined,
              label: "Dictionary",
              route: AppRoutes.dictionary,
            ),
            _navItem(
              context: context,
              icon: Icons.summarize_outlined,
              label: "Paragraph Summarizer",
              route: AppRoutes.summarizer,
            ),
            _navItem(
              context: context,
              icon: Icons.email_outlined,
              label: "Email Generator",
              route: AppRoutes.email,
            ),
            _navItem(
              context: context,
              icon: Icons.checklist_outlined,
              label: "Todo List",
              route: AppRoutes.todo,
            ),
            _navItem(
              context: context,
              icon: Icons.folder_open_outlined,
              label: "Knowledge Base (PDF Q&A)",
              route: AppRoutes.knowledge,
            ),

            const Spacer(),

            const Divider(color: Colors.white24),

            _navItem(
              context: context,
              icon: Icons.settings_outlined,
              label: "Settings",
              route: AppRoutes.settings,
            ),

            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }
}
