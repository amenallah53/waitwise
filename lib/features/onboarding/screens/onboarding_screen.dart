import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:waitwise/core/widgets/custom_appbar.dart';
import 'package:waitwise/core/widgets/custom_button.dart';
import 'package:waitwise/core/widgets/custom_text_field.dart';
import 'package:waitwise/features/onboarding/providers/onboarding_provider.dart';

class OnboardingScreen extends ConsumerStatefulWidget {
  const OnboardingScreen({super.key});

  @override
  ConsumerState<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends ConsumerState<OnboardingScreen> {
  final _scrollController = ScrollController();
  bool _showButton = false;

  static const _scrollThreshold = 80.0;

  static const _interests = [
    'Finance',
    'Career',
    'Wellness',
    'Tech',
    'Reading',
    'Other',
  ];

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    final shouldShow = _scrollController.offset > _scrollThreshold;
    if (shouldShow != _showButton) {
      setState(() => _showButton = shouldShow);
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(onboardingProvider);
    final notifier = ref.read(onboardingProvider.notifier);

    return Scaffold(
      appBar: CustomAppbar(),
      body: Stack(
        children: [
          // ── Scrollable content ───────────────────────────────────────────
          SingleChildScrollView(
            controller: _scrollController,
            child: SafeArea(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 40),

                    // ── Title ────────────────────────────────────────────
                    const Text(
                      "Let's make your\nwaiting time count",
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.w600,
                      ),
                    ),

                    const SizedBox(height: 32),

                    // ── Name input ───────────────────────────────────────
                    CustomTextField(
                      hintText: 'Your name',
                      onChanged: notifier.setName,
                    ),

                    const SizedBox(height: 24),

                    // ── Interests label ──────────────────────────────────
                    Text(
                      'What interests you?',
                      style: Theme.of(context).textTheme.headlineLarge
                          ?.copyWith(
                            color: Theme.of(context).colorScheme.primary,
                            fontSize: 14,
                          ),
                    ),

                    // ── Name input ───────────────────────────────────────
                    CustomTextField(
                      hintText: 'Your name',
                      onChanged: notifier.setName,
                    ),

                    const SizedBox(height: 24),

                    // ── Interests label ──────────────────────────────────
                    Text(
                      'What interests you?',
                      style: Theme.of(context).textTheme.headlineLarge
                          ?.copyWith(
                            color: Theme.of(context).colorScheme.primary,
                            fontSize: 14,
                          ),
                    ),

                    // ── Name input ───────────────────────────────────────
                    CustomTextField(
                      hintText: 'Your name',
                      onChanged: notifier.setName,
                    ),

                    const SizedBox(height: 24),

                    // ── Interests label ──────────────────────────────────
                    Text(
                      'What interests you?',
                      style: Theme.of(context).textTheme.headlineLarge
                          ?.copyWith(
                            color: Theme.of(context).colorScheme.primary,
                            fontSize: 14,
                          ),
                    ),

                    const SizedBox(height: 12),

                    // ── Interest chips ───────────────────────────────────
                    Wrap(
                      spacing: 10,
                      runSpacing: 10,
                      children: _interests.map((item) {
                        final isSelected = state.selectedInterests.contains(
                          item,
                        );

                        return GestureDetector(
                          onTap: () => notifier.toggleInterest(item),
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 200),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 24,
                              vertical: 12,
                            ),
                            decoration: BoxDecoration(
                              color: isSelected
                                  ? Theme.of(context).colorScheme.primary
                                  : const Color(0xFFF3F3F3),
                              borderRadius: BorderRadius.circular(9999),
                              boxShadow: isSelected
                                  ? [
                                      BoxShadow(
                                        color: Theme.of(
                                          context,
                                        ).colorScheme.primary.withOpacity(0.4),
                                        offset: const Offset(0, 4),
                                        blurRadius: 12,
                                      ),
                                    ]
                                  : [],
                            ),
                            child: Text(
                              item,
                              style: Theme.of(context).textTheme.bodyLarge
                                  ?.copyWith(
                                    fontSize: 16,
                                    color: isSelected
                                        ? Theme.of(
                                            context,
                                          ).colorScheme.onPrimary
                                        : Theme.of(
                                            context,
                                          ).colorScheme.onSurface,
                                  ),
                            ),
                          ),
                        );
                      }).toList(),
                    ),

                    const SizedBox(height: 24),

                    // ── Thoughts input ───────────────────────────────────
                    CustomTextField(
                      hintText: "What's on your mind lately?",
                      maxLines: 5,
                      onChanged: notifier.setThoughts,
                    ),

                    // Extra space so last field isn't hidden behind button
                    const SizedBox(height: 120),
                  ],
                ),
              ),
            ),
          ),

          // ── Slide-up button overlay ──────────────────────────────────────
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: AnimatedSlide(
              duration: const Duration(milliseconds: 380),
              curve: Curves.easeOutCubic,
              offset: _showButton ? Offset.zero : const Offset(0, 1),
              child: AnimatedOpacity(
                duration: const Duration(milliseconds: 300),
                opacity: _showButton ? 1.0 : 0.0,
                child: Container(
                  padding: const EdgeInsets.fromLTRB(24, 12, 24, 36),
                  decoration: BoxDecoration(color: Colors.transparent),
                  child: CustomButton(
                    text: 'Get Started',
                    onPressed: () => context.go('/home'),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
