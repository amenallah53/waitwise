import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:uuid/uuid.dart';
import 'package:waitwise/core/utils/current_user.dart';
import 'package:waitwise/core/widgets/custom_appbar.dart';
import 'package:waitwise/core/widgets/custom_button.dart';
import 'package:waitwise/core/widgets/custom_text_field.dart';
import 'package:waitwise/data/datasources/users_service.dart';
import 'package:waitwise/data/models/user_model.dart';
import 'package:waitwise/features/onboarding/providers/onboarding_provider.dart';

class OnboardingScreen extends ConsumerStatefulWidget {
  const OnboardingScreen({super.key});

  @override
  ConsumerState<OnboardingScreen> createState() => _OnboardingScreenState();
}

// ── Section label helper ───────────────────────────────────────────────────────
Widget _sectionLabel(BuildContext context, String text) {
  return Text(
    text,
    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
      fontSize: 12,
      fontWeight: FontWeight.w600,
      letterSpacing: 1,
      color: Theme.of(context).colorScheme.primary,
    ),
  );
}

class _OnboardingScreenState extends ConsumerState<OnboardingScreen> {
  final _scrollController = ScrollController();
  bool _showButton = false;
  bool showCustomInput = false;
  final TextEditingController customController = TextEditingController();

  static const _scrollThreshold = 20.0;
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
    customController.dispose();
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

    final allInterests = [..._interests, ...state.customInterests];

    return Scaffold(
      appBar: const CustomAppbar(),
      body: Stack(
        children: [
          // ── Scrollable content ─────────────────────────────────────────
          SingleChildScrollView(
            controller: _scrollController,
            child: SafeArea(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 24),

                    // ── Title ──────────────────────────────────────────
                    RichText(
                      text: TextSpan(
                        style: Theme.of(context).textTheme.headlineLarge
                            ?.copyWith(fontSize: 26, color: Colors.black),
                        children: [
                          const TextSpan(text: "Design your\nperfect "),
                          TextSpan(
                            text: "interval.",
                            style: TextStyle(
                              color: Theme.of(context).colorScheme.primary,
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 12),

                    Text(
                      "Let's set up your space for mindful growth and intentional waiting.",
                      style: Theme.of(
                        context,
                      ).textTheme.bodyLarge?.copyWith(color: Colors.grey[600]),
                    ),

                    const SizedBox(height: 24),

                    // ── Name ───────────────────────────────────────────
                    _sectionLabel(context, "WHAT'S YOUR NAME?"),
                    const SizedBox(height: 8),
                    CustomTextField(
                      hintText: 'e.g. Alex',
                      onChanged: notifier.setName,
                    ),

                    const SizedBox(height: 24),

                    // ── Interests ──────────────────────────────────────
                    _sectionLabel(context, "CHOOSE YOUR FOCUS AREAS"),
                    const SizedBox(height: 12),

                    Wrap(
                      spacing: 12,
                      runSpacing: 12,
                      children: allInterests.map((item) {
                        final isSelected = state.selectedInterests.contains(
                          item,
                        );

                        return GestureDetector(
                          onTap: () {
                            if (item == 'Other') {
                              setState(() => showCustomInput = true);
                            } else {
                              notifier.toggleInterest(item);
                            }
                          },
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 200),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 10,
                            ),
                            decoration: BoxDecoration(
                              color: isSelected
                                  ? Theme.of(context).colorScheme.primary
                                  : Colors.white,
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(
                                color: isSelected
                                    ? Theme.of(context).colorScheme.primary
                                    : Colors.grey.shade300,
                              ),
                            ),
                            child: Text(
                              item,
                              style: TextStyle(
                                color: isSelected
                                    ? Colors.white
                                    : Colors.black87,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                    ),

                    // ── Custom interest input ──────────────────────────
                    AnimatedSwitcher(
                      duration: const Duration(milliseconds: 300),
                      child: showCustomInput
                          ? Padding(
                              key: const ValueKey('custom_input'),
                              padding: const EdgeInsets.only(top: 16),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: CustomTextField(
                                      hintText: 'Your custom focus...',
                                      controller: customController,
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  GestureDetector(
                                    onTap: () {
                                      final value = customController.text
                                          .trim();
                                      if (value.isEmpty) return;
                                      notifier.addCustomInterest(value);
                                      customController.clear();
                                      setState(() => showCustomInput = false);
                                    },
                                    child: Container(
                                      padding: const EdgeInsets.all(14),
                                      decoration: BoxDecoration(
                                        color: Theme.of(
                                          context,
                                        ).colorScheme.primary,
                                        shape: BoxShape.circle,
                                      ),
                                      child: const Icon(
                                        Icons.check,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            )
                          : const SizedBox(key: ValueKey('empty')),
                    ),

                    const SizedBox(height: 24),

                    // ── Thoughts ───────────────────────────────────────
                    _sectionLabel(context, "WHAT'S ON YOUR MIND LATELY?"),
                    const SizedBox(height: 8),
                    CustomTextField(
                      hintText:
                          "Ideas, projects, or tasks you've been putting off...",
                      maxLines: 4,
                      onChanged: notifier.setThoughts,
                    ),

                    const SizedBox(height: 24),

                    // ── Image ──────────────────────────────────────────
                    ClipRRect(
                      borderRadius: BorderRadius.circular(24),
                      child: Image.asset(
                        'assets/images/onboarding_room.jpg',
                        height: 160,
                        width: double.infinity,
                        fit: BoxFit.cover,
                      ),
                    ),

                    const SizedBox(height: 16),

                    // ── Footer ─────────────────────────────────────────
                    Center(
                      child: Text(
                        'You can change these preferences at any time in your Dashboard.',
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          fontSize: 12,
                          color: Colors.grey,
                        ),
                      ),
                    ),

                    const SizedBox(height: 120),
                  ],
                ),
              ),
            ),
          ),

          // ── Slide-up Get Started button ────────────────────────────────
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
                  child:
                      // ── Drop this into your onboarding screen ────────────────────────────────────
                      // onPressed is now () async => void — CustomButton handles the loading state
                      CustomButton(
                        text: 'Get Started',
                        onPressed: state.isReady
                            ? () async {
                                final newUserId = const Uuid().v4();
                                final newCurrentUser = UserModel(
                                  id: newUserId,
                                  name: state.name,
                                  interests: state.selectedInterests.toList(),
                                  backlogs: [
                                    UserBacklog(
                                      userId: newUserId,
                                      content: state.thoughts,
                                      date: DateTime.now(),
                                    ),
                                  ],
                                  createdAt: DateTime.now(),
                                );

                                // 1. Save locally
                                saveCurrentUser(newCurrentUser);

                                // 2. Save to Supabase — button shows spinner while this runs
                                await saveUserToDb(newCurrentUser);

                                // 3. Mark onboarding done
                                markOnboardingDone();

                                // 4. Reset provider
                                notifier.reset();

                                // 5. Navigate
                                if (context.mounted) context.go('/home');
                              }
                            : null,
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
