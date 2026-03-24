import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final nameController = TextEditingController();
  final thoughtsController = TextEditingController();

  final interests = ["Finance", "Career", "Wellness", "Tech", "Reading"];

  final selected = <String>{};

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 40),

              /// TITLE (asymmetrical feel)
              const Text(
                "Let’s make your\nwaiting time count",
                style: TextStyle(fontSize: 28, fontWeight: FontWeight.w600),
              ),

              const SizedBox(height: 32),

              /// NAME INPUT
              _buildInput(controller: nameController, hint: "Your name"),

              const SizedBox(height: 24),

              /// INTERESTS
              const Text("What interests you?"),

              const SizedBox(height: 12),

              Wrap(
                spacing: 10,
                runSpacing: 10,
                children: interests.map((item) {
                  final isSelected = selected.contains(item);

                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        isSelected ? selected.remove(item) : selected.add(item);
                      });
                    },
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 10,
                      ),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? const Color(0xFFE1BEE7)
                            : const Color(0xFFF3F3F3),
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: Text(item),
                    ),
                  );
                }).toList(),
              ),

              const SizedBox(height: 24),

              /// BACKLOG INPUT
              _buildInput(
                controller: thoughtsController,
                hint: "What's on your mind lately?",
                maxLines: 3,
              ),

              const Spacer(),

              /// CTA
              GestureDetector(
                onTap: () {
                  context.go('/home');
                },
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 18),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(999),
                    gradient: const LinearGradient(
                      colors: [Color(0xFF7E0092), Color(0xFF9C27B0)],
                    ),
                  ),
                  alignment: Alignment.center,
                  child: const Text(
                    "Get Started",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),

              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInput({
    required TextEditingController controller,
    required String hint,
    int maxLines = 1,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFF3F3F3),
        borderRadius: BorderRadius.circular(30),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: TextField(
        controller: controller,
        maxLines: maxLines,
        decoration: InputDecoration(hintText: hint, border: InputBorder.none),
      ),
    );
  }
}
