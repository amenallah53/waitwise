import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:waitwise/core/widgets/custom_appbar.dart';
import 'package:waitwise/core/widgets/custom_text_field.dart';
import 'package:waitwise/core/widgets/custom_button.dart'; // Ensure this import matches your file structure
import 'package:waitwise/data/models/session_model.dart';
import 'package:waitwise/features/active_session/providers/reflection_provider.dart';
import 'package:waitwise/features/session_complete/screens/session_complete_screen.dart';
import 'package:waitwise/features/session_complete/providers/session_complete_provider.dart';

class ReflectionScreen extends ConsumerStatefulWidget {
  final ReflectionSession session;
  const ReflectionScreen({super.key, required this.session});

  @override
  ConsumerState<ReflectionScreen> createState() => _ReflectionScreenState();
}

class _ReflectionScreenState extends ConsumerState<ReflectionScreen> {
  late TextEditingController _reflectionController;

  @override
  void initState() {
    super.initState();
    // We initialize with the current provider value (if any)
    _reflectionController = TextEditingController(
      text: ref.read(reflectionProvider).response,
    );
  }

  @override
  void dispose() {
    _reflectionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(reflectionProvider);
    final notifier = ref.read(reflectionProvider.notifier);
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;

    return Scaffold(
      appBar: const CustomAppbar(),
      backgroundColor: theme.scaffoldBackgroundColor,
      body: SafeArea(
        child: Column(
          children: [
            // ── Scrollable Area ───────────────────────────
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  children: [
                    const SizedBox(height: 24),

                    // ── Timer Circle ─────────────────────────────
                    SizedBox(
                      width: 120,
                      height: 120,
                      child: Stack(
                        fit: StackFit.expand,
                        children: [
                          CircularProgressIndicator(
                            value: state.remainingSeconds / 300, // 5 min = 300s
                            color: theme.colorScheme.primary,
                            strokeWidth: 8,
                            backgroundColor: scheme.primary.withOpacity(0.1),
                            strokeCap: StrokeCap.round,
                          ),
                          Center(
                            child: Text(
                              "${(state.remainingSeconds ~/ 60).toString().padLeft(1, '0')}:${(state.remainingSeconds % 60).toString().padLeft(2, '0')}",
                              style: theme.textTheme.headlineMedium?.copyWith(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 32),

                    // ── Question Card ───────────────────────────
                    Container(
                      padding: const EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(24),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.05),
                            offset: const Offset(0, 4),
                            blurRadius: 12,
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'REFLECTION MOMENT',
                            style: theme.textTheme.bodyLarge?.copyWith(
                              fontWeight: FontWeight.w600,
                              color: theme.colorScheme.primary,
                            ),
                          ),
                          const SizedBox(height: 12),
                          const Text(
                            "If you had an extra hour today, what's the one thing you'd do for yourself?",
                          ),
                          const SizedBox(height: 16),
                          CustomTextField(
                            hintText: 'Start typing your thoughts here...',
                            maxLines: 4,
                            controller: _reflectionController,
                            onChanged: (value) {
                              // We manually update the provider so your markDone() logic stays valid
                              ref
                                  .read(reflectionProvider.notifier)
                                  .updateResponse(value);
                            },
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 24),

                    // ── Image previews ──────────────────────────
                    Row(
                      children: [
                        Expanded(
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(16),
                            child: Image.asset(
                              'assets/images/reflection1.png',
                              height: 120,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(16),
                            child: Image.asset(
                              'assets/images/reflection2.png',
                              height: 120,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ),

            // ── Fixed Action Buttons using CustomButton ──
            // ── Fixed Action Buttons ─────────────────────
            Padding(
              padding: const EdgeInsets.all(24),
              child: Row(
                children: [
                  // ── Custom Skip Button (White BG, Violet Text) ──
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        _reflectionController.clear();
                        notifier.clear();
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 18),
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(9999),
                          border: Border.all(
                            color: const Color(0xFF9C27B0),
                            width: 1.5,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.05),
                              offset: const Offset(0, 4),
                              blurRadius: 10,
                            ),
                          ],
                        ),
                        child: Text(
                          'Skip',
                          style: theme.textTheme.bodyLarge?.copyWith(
                            color: const Color(0xFF9C27B0), // Violet
                            fontWeight: FontWeight.w700,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  // ── Done Button (Gradient + Icon) ──
                  Expanded(
                    child: CustomButton(
                      text: 'Done',
                      icon: const Icon(
                        Icons.check_circle_outline,
                        color: Colors.white,
                        size: 20,
                      ),
                      onPressed:
                          (state.response.isNotEmpty ||
                              state.remainingSeconds == 0)
                          ? () {
                              notifier.markDone();
                              ref
                                  .read(sessionCompleteProvider.notifier)
                                  .setSessionData(
                                    minutesSpent: 25,
                                    sessionsThisWeek: 3,
                                    currentStreak: 5,
                                  );
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => const SessionCompleteScreen(),
                                ),
                              );
                            }
                          : null,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
