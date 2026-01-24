import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'intro_page1.dart';
import 'intro_page2.dart';
import 'intro_page3.dart';
import '../home/home_screen.dart'; // Your dashboard screen

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _controller = PageController();
  bool isLastPage = false;

  Future<void> completeOnboarding() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool("onboarding_done", true);

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const HomeScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0D0D0F),
      body: Stack(
        children: [
          PageView(
            controller: _controller,
            onPageChanged: (index) {
              setState(() {
                isLastPage = index == 2;
              });
            },
            children: const [
              IntroPage1(),
              IntroPage2(),
              IntroPage3(),
            ],
          ),

          // Bottom navigation dots + buttons
          Positioned(
            bottom: 30,
            left: 20,
            right: 20,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Skip button
                if (!isLastPage)
                  TextButton(
                    onPressed: completeOnboarding,
                    child: const Text(
                      "Skip",
                      style: TextStyle(color: Colors.white70, fontSize: 16),
                    ),
                  )
                else
                  const SizedBox(width: 60),

                // Page Dots
                Row(
                  children: List.generate(3, (index) {
                    return AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      width: 10,
                      height: 10,
                      margin: const EdgeInsets.symmetric(horizontal: 4),
                      decoration: BoxDecoration(
                        color: (_controller.hasClients &&
                                _controller.page?.round() == index)
                            ? Colors.blueAccent
                            : Colors.white24,
                        shape: BoxShape.circle,
                      ),
                    );
                  }),
                ),

                // Next / Done button
                if (!isLastPage)
                  ElevatedButton(
                    onPressed: () {
                      _controller.nextPage(
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.easeOut,
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF4F8CFF),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text("Next"),
                  )
                else
                  const SizedBox(width: 60),
              ],
            ),
          )
        ],
      ),
    );
  }
}
