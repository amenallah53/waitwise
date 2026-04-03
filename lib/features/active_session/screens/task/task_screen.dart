import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:waitwise/core/widgets/custom_appbar.dart';
import 'package:waitwise/core/widgets/custom_circular_timer.dart';
import 'package:waitwise/data/datasources/sessions_service.dart';
import 'package:waitwise/data/models/session_model.dart';
import 'package:waitwise/features/active_session/providers/tasks_provider.dart';
import 'package:waitwise/features/session_complete/providers/session_complete_provider.dart';
import 'dart:async'; // Required for Timer

// ─── Local State for Task Checkboxes ──────────────────────────
// Since TaskContent is immutable in the model, we handle the UI state here
class TasksScreen extends ConsumerStatefulWidget {
  final TaskSession session;
  const TasksScreen({super.key, required this.session});

  @override
  ConsumerState<TasksScreen> createState() => _TasksScreenState();
}

class _TasksScreenState extends ConsumerState<TasksScreen> {
  late List<bool> _taskCompletion;
  // Inside _TasksScreenState
  Timer? _timer;
  @override
  void initState() {
    super.initState();
    // 1. Reset the provider state immediately when the screen loads
    // We use Future.microtask to avoid calling provider updates during build
    Future.microtask(() {
      ref.read(tasksProvider.notifier).resetTimer();
    });
    // Initialize checkboxes based on the model's steps
    _taskCompletion = widget.session.aiContent.steps
        .map((s) => s.isComplete)
        .toList();

    // Start the countdown
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      ref.read(tasksProvider.notifier).decrementTimer();
    });
  }

  @override
  void dispose() {
    _timer?.cancel(); // Important: Stop the timer when leaving the screen
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    //final scheme = theme.colorScheme;
    final steps = widget.session.aiContent.steps;
    //final state = ref.watch(tasksProvider);
    return Scaffold(
      appBar: CustomAppbar(needToShowBack: true),
      backgroundColor: theme.scaffoldBackgroundColor,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  children: [
                    const SizedBox(height: 24),

                    // ── Circular timer ────────────────────────────────────────────
                    CustomCircularTimer(
                      color: theme.colorScheme.secondary,
                      durationMinutes: widget.session.durationMinutes,
                      onComplete: () {
                        updateSessionCompletion(widget.session.id!, true);
                        context.go(
                          '/session/active/${widget.session.id}/complete',
                          extra: {
                            'durationMinutes': widget.session.durationMinutes,
                          },
                        );
                      },
                    ),
                    const SizedBox(height: 48),

                    // ── Header Text ──────────────────────────────────
                    Text(
                      "Micro-Task: ${widget.session.title ?? 'Organize Your Workspace'}",
                      textAlign: TextAlign.center,
                      style: theme.textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                        fontSize: 24,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      "Transform your wait time into a moment of focus.",
                      textAlign: TextAlign.center,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: Colors.grey[600],
                      ),
                    ),

                    const SizedBox(height: 32),

                    // ── Task Checklist Card ──────────────────────────
                    // ────────────────
                    Container(
                      padding: const EdgeInsets.symmetric(
                        vertical: 20,
                        horizontal: 16,
                      ), // More internal padding
                      decoration: BoxDecoration(
                        color: const Color(0xFFF5F5F5),
                        borderRadius: BorderRadius.circular(32),
                      ),
                      child: Column(
                        children: List.generate(steps.length, (index) {
                          final isDone = _taskCompletion[index];

                          return Column(
                            children: [
                              GestureDetector(
                                onTap: () => setState(
                                  () => _taskCompletion[index] =
                                      !_taskCompletion[index],
                                ),
                                behavior: HitTestBehavior
                                    .opaque, // Makes the whole row clickable
                                child: Row(
                                  children: [
                                    // Custom Checkbox Circle
                                    Container(
                                      width: 24,
                                      height: 24,
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: isDone
                                            ? const Color(0xFF006D5B)
                                            : Colors.transparent,
                                        border: Border.all(
                                          color: const Color(0xFF006D5B),
                                          width: 2,
                                        ),
                                      ),
                                      child: isDone
                                          ? const Icon(
                                              Icons.check,
                                              size: 16,
                                              color: Colors.white,
                                            )
                                          : null,
                                    ),
                                    const SizedBox(
                                      width: 16,
                                    ), // Space between circle and text
                                    // Task Text
                                    Expanded(
                                      child: Text(
                                        steps[index].text,
                                        style: TextStyle(
                                          color: isDone
                                              ? Colors.grey
                                              : Colors.black87,
                                          decoration: isDone
                                              ? TextDecoration.lineThrough
                                              : null,
                                          fontSize: 16,
                                          height:
                                              1.4, // Improves readability for multi-line tasks
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              // ── Separation Logic ──
                              if (index != steps.length - 1)
                                const SizedBox(
                                  height: 20,
                                ), // Adjust this value for more/less separation
                            ],
                          );
                        }),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // ── Footer Buttons ───────────────────────────────────────
            Padding(
              padding: const EdgeInsets.all(24),
              child: Row(
                children: [
                  // ── Skip Button: White BG, Thin Grey/Teal Border ──────────
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        context.go('/home');
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 18),
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(9999),
                          // Using a very light border as seen in the screenshot
                          border: Border.all(
                            color: const Color(0xFF006D5B).withOpacity(0.1),
                            width: 1,
                          ),
                        ),
                        child: const Text(
                          'Skip',
                          style: TextStyle(
                            color: Color(
                              0xFF006D5B,
                            ), // Teal text to match "Done"
                            fontWeight: FontWeight.w600,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  // ── Done Button: Solid Teal (Matching Image) ──────────────
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        ref
                            .read(sessionCompleteProvider.notifier)
                            .setSessionData(
                              minutesSpent: widget.session.durationMinutes,
                              sessionsThisWeek: 4,
                              currentStreak: 6,
                            );
                        updateSessionCompletion(widget.session.id!, true);
                        context.go(
                          '/session/active/${widget.session.id}/complete',
                          extra: {
                            'durationMinutes': widget.session.durationMinutes,
                          },
                        );
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: const Color(
                            0xFF006D5B,
                          ), // Deep Teal from screenshot
                          borderRadius: BorderRadius.circular(9999),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              offset: const Offset(0, 4),
                              blurRadius: 8,
                            ),
                          ],
                        ),
                        child: const Text(
                          'Done',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                            fontSize: 16,
                          ),
                        ),
                      ),
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
