import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:waitwise/core/widgets/custom_text_field.dart';
import 'package:waitwise/features/active_session/providers/reflection_provider.dart';
import 'package:waitwise/features/session_complete/screens/session_complete_screen.dart';
import 'package:waitwise/features/session_complete/providers/session_complete_provider.dart';

class ReflectionScreen extends ConsumerWidget {
  const ReflectionScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(reflectionProvider);
    final notifier = ref.read(reflectionProvider.notifier);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text('Reflection Moment'),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Padding(
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
                      color: Theme.of(context).colorScheme.primary,
                      strokeWidth: 8,
                    ),
                    Center(
                      child: Text(
                        "${(state.remainingSeconds ~/ 60).toString().padLeft(1, '0')}:${(state.remainingSeconds % 60).toString().padLeft(2, '0')}",
                        style: Theme.of(
                          context,
                        ).textTheme.headlineMedium?.copyWith(fontSize: 20),
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
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: Theme.of(context).colorScheme.primary,
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
                      onChanged: notifier.updateResponse,
                      //controller: TextEditingController(text: state.response),
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

              const Spacer(),

              // ── Action Buttons ─────────────────────────
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () {
                        notifier.clear();
                      },
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                      child: const Text('Skip'),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: ElevatedButton(
                      onPressed:
                          (state.response.isNotEmpty ||
                              state.remainingSeconds == 0)
                          ? () {
                              //mark notifier as done to move to next screen
                              notifier.markDone();
                              //2. set session complete data in session complete provider
                              ref
                                  .read(sessionCompleteProvider.notifier)
                                  .setSessionData(
                                    minutesSpent:
                                        25, // should be real minutes from session
                                    sessionsThisWeek:
                                        3, // fetch from user /session data
                                    currentStreak:
                                        5, // fetch from user /session data
                                  );
                              //3. Navigate to session complete screen
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => const SessionCompleteScreen(),
                                ),
                              );
                            }
                          : null,
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                      child: const Text('Done'),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}
