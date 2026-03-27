import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:waitwise/core/widgets/custom_appbar.dart';
import 'package:waitwise/core/widgets/custom_button.dart';
import 'package:waitwise/data/models/session_model.dart';
import 'package:waitwise/features/active_session/providers/quiz_provider.dart';

class QuizScreen extends ConsumerWidget {
  final QuizSession session;

  const QuizScreen({super.key, required this.session});

  // Letter labels for options
  static const _letters = ['A', 'B', 'C', 'D', 'E'];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(quizProvider(session));
    final notifier = ref.read(quizProvider(session).notifier);
    final theme = Theme.of(context);
    final question = state.currentQuestion;

    // Navigate away when done
    if (state.done) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        context.go('/session/complete');
      });
    }

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: CustomAppbar(needToShowBack: true),
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 32),

            // ── Circular timer ────────────────────────────────────────────
            _CircularTimer(durationMinutes: session.durationMinutes),

            const SizedBox(height: 32),

            // ── Scrollable content ────────────────────────────────────────
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // ── Type label ───────────────────────────────────────
                    Text(
                      'KNOWLEDGE BOOST',
                      style: theme.textTheme.bodyLarge?.copyWith(
                        color: theme.colorScheme.tertiary,
                        fontWeight: FontWeight.w800,
                        fontSize: 14,
                        letterSpacing: 1.2,
                      ),
                    ),

                    const SizedBox(height: 8),

                    // ── Session title ────────────────────────────────────
                    Text(
                      session.title ?? 'Quick Quiz',
                      style: theme.textTheme.headlineMedium?.copyWith(
                        fontWeight: FontWeight.w800,
                        fontSize: 28,
                        color: theme.colorScheme.onSurface,
                        height: 1.2,
                      ),
                    ),

                    const SizedBox(height: 24),

                    // ── Question card ────────────────────────────────────
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF3F3F3),
                        borderRadius: BorderRadius.circular(24),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.04),
                            blurRadius: 10,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Text(
                        '"${question.question}"',
                        style: theme.textTheme.bodyLarge?.copyWith(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: theme.colorScheme.onSurface,
                          height: 1.5,
                        ),
                      ),
                    ),

                    const SizedBox(height: 24),

                    // ── Options ──────────────────────────────────────────
                    ...question.options.asMap().entries.map((entry) {
                      final i = entry.key;
                      final text = entry.value;
                      final isSelected = state.selectedOptionIndex == i;
                      final isCorrect =
                          state.confirmed && i == question.correctIndex;
                      final isWrong =
                          state.confirmed &&
                          isSelected &&
                          i != question.correctIndex;

                      Color cardColor = Colors.white;
                      Color borderColor = Colors.transparent;
                      Color letterBg = theme.colorScheme.onSurface.withOpacity(
                        0.08,
                      );
                      Color letterColor = theme.colorScheme.onSurface
                          .withOpacity(0.5);
                      Color textColor = theme.colorScheme.onSurface;

                      if (isCorrect) {
                        cardColor = const Color(0xFFF0FFF4);
                        borderColor = const Color(0xFF43A047);
                        letterBg = const Color(0xFF43A047);
                        letterColor = Colors.white;
                      } else if (isWrong) {
                        cardColor = const Color(0xFFFFF0F0);
                        borderColor = Colors.red.shade300;
                        letterBg = Colors.red.shade300;
                        letterColor = Colors.white;
                      } else if (isSelected) {
                        cardColor = theme.colorScheme.tertiary.withOpacity(
                          0.08,
                        );
                        borderColor = theme.colorScheme.tertiary;
                        letterBg = theme.colorScheme.tertiary;
                        letterColor = Colors.white;
                        textColor = theme.colorScheme.onSurface;
                      }

                      return Padding(
                        padding: const EdgeInsets.only(bottom: 16),
                        child: GestureDetector(
                          onTap: () => notifier.selectOption(i),
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 200),
                            curve: Curves.easeOutCubic,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 16,
                            ),
                            decoration: BoxDecoration(
                              color: cardColor,
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(
                                color: borderColor,
                                width: 1.5,
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.03),
                                  blurRadius: 6,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                            ),
                            child: Row(
                              children: [
                                // Letter bubble
                                AnimatedContainer(
                                  duration: const Duration(milliseconds: 200),
                                  width: 32,
                                  height: 32,
                                  decoration: BoxDecoration(
                                    color: letterBg,
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Center(
                                    child: Text(
                                      _letters[i],
                                      style: TextStyle(
                                        color: letterColor,
                                        fontWeight: FontWeight.w800,
                                        fontSize: 13,
                                      ),
                                    ),
                                  ),
                                ),

                                const SizedBox(width: 16),

                                // Option text
                                Expanded(
                                  child: Text(
                                    text,
                                    style: theme.textTheme.bodyLarge?.copyWith(
                                      fontSize: 16,
                                      fontWeight: isSelected
                                          ? FontWeight.w700
                                          : FontWeight.w500,
                                      color: textColor,
                                      height: 1.3,
                                    ),
                                  ),
                                ),

                                // Check icon when confirmed correct
                                if (isCorrect)
                                  const Icon(
                                    Icons.check_circle_rounded,
                                    color: Color(0xFF43A047),
                                    size: 20,
                                  ),
                              ],
                            ),
                          ),
                        ),
                      );
                    }),

                    // ── Explanation (shown after confirm) ────────────────
                    if (state.confirmed) ...[
                      const SizedBox(height: 16),
                      AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        width: double.infinity,
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: theme.colorScheme.primary.withOpacity(0.06),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: theme.colorScheme.primary.withOpacity(0.2),
                          ),
                        ),
                        child: Text(
                          question.explanation,
                          style: theme.textTheme.bodyLarge?.copyWith(
                            color: theme.colorScheme.onSurface.withOpacity(0.7),
                            fontSize: 14,
                            height: 1.5,
                          ),
                        ),
                      ),
                    ],

                    const SizedBox(height: 32), // space for bottom buttons
                  ],
                ),
              ),
            ),

            // ── Bottom actions ────────────────────────────────────────────
            Container(
              padding: const EdgeInsets.fromLTRB(24, 12, 24, 28),
              decoration: BoxDecoration(
                color: const Color(0xFFF9F9F9),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.04),
                    blurRadius: 12,
                    offset: const Offset(0, -4),
                  ),
                ],
              ),
              child: Column(
                children: [
                  // Skip / Done row
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      GestureDetector(
                        onTap: notifier.skip,
                        child: Row(
                          children: [
                            Icon(
                              Icons.skip_next_rounded,
                              size: 16,
                              color: theme.colorScheme.onSurface.withOpacity(
                                0.4,
                              ),
                            ),
                            const SizedBox(width: 4),
                            Text(
                              'Skip',
                              style: theme.textTheme.bodyMedium?.copyWith(
                                color: theme.colorScheme.onSurface.withOpacity(
                                  0.4,
                                ),
                                fontWeight: FontWeight.w600,
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                      ),
                      GestureDetector(
                        onTap: state.confirmed ? notifier.next : null,
                        child: Row(
                          children: [
                            Icon(
                              Icons.check_rounded,
                              size: 16,
                              color: state.confirmed
                                  ? theme.colorScheme.primary
                                  : theme.colorScheme.onSurface.withOpacity(
                                      0.2,
                                    ),
                            ),
                            const SizedBox(width: 4),
                            Text(
                              'Done',
                              style: theme.textTheme.bodyMedium?.copyWith(
                                color: state.confirmed
                                    ? theme.colorScheme.primary
                                    : theme.colorScheme.onSurface.withOpacity(
                                        0.2,
                                      ),
                                fontWeight: FontWeight.w700,
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 14),

                  // Confirm button
                  CustomButton(
                    text: state.confirmed
                        ? state.isLastQuestion
                              ? 'Finish'
                              : 'Next Question'
                        : 'Confirm',
                    onPressed: state.confirmed
                        ? notifier.next
                        : state.hasSelection
                        ? notifier.confirm
                        : null,
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

// ── Circular countdown timer ───────────────────────────────────────────────────

class _CircularTimer extends StatefulWidget {
  final int durationMinutes;

  const _CircularTimer({required this.durationMinutes});

  @override
  State<_CircularTimer> createState() => _CircularTimerState();
}

class _CircularTimerState extends State<_CircularTimer>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(minutes: widget.durationMinutes),
    );

    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        // navigate when timer ends
        if (mounted) {
          context.go('/session/complete');
        }
      }
    });

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  String _formatTime(double progress) {
    final totalSeconds = (widget.durationMinutes * 60 * (1 - progress)).round();
    final m = totalSeconds ~/ 60;
    final s = totalSeconds % 60;
    return '$m:${s.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return AnimatedBuilder(
      animation: _controller,
      builder: (context, _) {
        return SizedBox(
          width: 110,
          height: 110,
          child: Stack(
            fit: StackFit.expand,
            children: [
              CircularProgressIndicator(
                value: 1 - _controller.value,
                strokeWidth: 8,
                backgroundColor: theme.colorScheme.tertiary.withOpacity(0.15),
                valueColor: AlwaysStoppedAnimation<Color>(
                  theme.colorScheme.tertiary,
                ),
                strokeCap: StrokeCap.round,
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Remaining',
                    style: theme.textTheme.labelSmall?.copyWith(
                      fontSize: 10,
                      color: theme.colorScheme.onSurface.withOpacity(0.4),
                      letterSpacing: 0.3,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    _formatTime(_controller.value),
                    style: theme.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w800,
                      fontSize: 22,
                      color: theme.colorScheme.onSurface,
                      letterSpacing: -0.5,
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}
