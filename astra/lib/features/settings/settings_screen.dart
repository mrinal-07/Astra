import 'package:flutter/material.dart';
import 'package:astra/widgets/astra_page.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const AstraPage(
      title: "Settings",
      child: SettingsBody(),
    );
  }
}

class SettingsBody extends StatefulWidget {
  const SettingsBody({super.key});

  @override
  State<SettingsBody> createState() => _SettingsBodyState();
}

class _SettingsBodyState extends State<SettingsBody> {
  bool darkMode = true;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SwitchListTile(
          title: const Text("Dark Mode", style: TextStyle(color: Colors.white)),
          value: darkMode,
          onChanged: (val) => setState(() => darkMode = val),
        ),

        const SizedBox(height: 20),

        const Text(
          "More settings coming soon...",
          style: TextStyle(color: Colors.white54),
        ),
      ],
    );
  }
}
