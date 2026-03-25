import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:waitwise/core/widgets/custom_appbar.dart';
import 'package:waitwise/core/widgets/custom_button.dart';
import 'package:waitwise/core/widgets/custom_text_field.dart';
import 'package:waitwise/features/onboarding/providers/onboarding_provider.dart';

class OnboardingScreen extends ConsumerWidget {
  const OnboardingScreen({super.key});

  static const _interests = [
    'Finance',
    'Career',
    'Wellness',
    'Tech',
    'Reading',
    'Other',
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(onboardingProvider);
    final notifier = ref.read(onboardingProvider.notifier);

    return Scaffold(
      appBar: CustomAppbar(),
      body: SingleChildScrollView(
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 40),

                // ── Title ──────────────────────────────────────────────────
                const Text(
                  "Let's make your\nwaiting time count",
                  style: TextStyle(fontSize: 28, fontWeight: FontWeight.w600),
                ),

                const SizedBox(height: 32),

                // ── Name input ─────────────────────────────────────────────
                CustomTextField(
                  hintText: 'Your name',
                  onChanged: notifier.setName,
                ),

                const SizedBox(height: 24),

                // ── Interests label ────────────────────────────────────────
                Text(
                  'What interests you?',
                  style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                    color: Theme.of(context).colorScheme.primary,
                    fontSize: 14,
                  ),
                ),

                const SizedBox(height: 12),

                // ── Interest chips ─────────────────────────────────────────
                Wrap(
                  spacing: 10,
                  runSpacing: 10,
                  children: _interests.map((item) {
                    final isSelected = state.selectedInterests.contains(item);

                    return GestureDetector(
                      onTap: () => notifier.toggleInterest(item),
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

                // ── Thoughts input ─────────────────────────────────────────
                CustomTextField(
                  hintText: "What's on your mind lately?",
                  maxLines: 3,
                  onChanged: notifier.setThoughts,
                ),

                const SizedBox(height: 32),

                // ── CTA ────────────────────────────────────────────────────
                CustomButton(
                  text: 'Get Started',
                  onPressed: () => context.go('/session'),
                ),

                const SizedBox(height: 24),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
