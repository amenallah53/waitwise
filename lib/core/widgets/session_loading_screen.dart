// ============================================================
// lib/core/widgets/session_loading_screen.dart
// ============================================================

import 'dart:async';
import 'package:flutter/material.dart';

class SessionLoadingScreen extends StatefulWidget {
  const SessionLoadingScreen({super.key});

  @override
  State<SessionLoadingScreen> createState() => _SessionLoadingScreenState();
}

class _SessionLoadingScreenState extends State<SessionLoadingScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _spinController;

  final List<_LoadingStep> _steps = const [
    _LoadingStep(message: 'Workflow just started...', delay: 0),
    _LoadingStep(message: 'Fetching your backlog & past sessions...', delay: 3),
    _LoadingStep(
      message: 'AI agent is deciding your session type...',
      delay: 7,
    ),
    _LoadingStep(message: 'Almost there, please wait...', delay: 13),
  ];

  int _currentStep = 0;
  final List<Timer> _timers = [];

  @override
  void initState() {
    super.initState();

    _spinController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    )..repeat();

    for (int i = 1; i < _steps.length; i++) {
      final step = i;
      _timers.add(
        Timer(Duration(seconds: _steps[step].delay), () {
          if (!mounted) return;
          setState(() => _currentStep = step);
        }),
      );
    }
  }

  @override
  void dispose() {
    _spinController.dispose();
    for (final t in _timers) {
      t.cancel();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: const Color(0xFFF9F9F9),
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 48),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // ── Spinner ───────────────────────────────────────────────
                RotationTransition(
                  turns: _spinController,
                  child: Container(
                    width: 56,
                    height: 56,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: theme.colorScheme.primary.withOpacity(0.15),
                        width: 4,
                      ),
                    ),
                    child: Align(
                      alignment: Alignment.topCenter,
                      child: Container(
                        width: 8,
                        height: 8,
                        margin: const EdgeInsets.only(top: 2),
                        decoration: BoxDecoration(
                          color: theme.colorScheme.primary,
                          shape: BoxShape.circle,
                        ),
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 40),

                // ── Animated message ──────────────────────────────────────
                AnimatedSwitcher(
                  duration: const Duration(milliseconds: 500),
                  transitionBuilder: (child, animation) => FadeTransition(
                    opacity: animation,
                    child: SlideTransition(
                      position:
                          Tween<Offset>(
                            begin: const Offset(0, 0.2),
                            end: Offset.zero,
                          ).animate(
                            CurvedAnimation(
                              parent: animation,
                              curve: Curves.easeOutCubic,
                            ),
                          ),
                      child: child,
                    ),
                  ),
                  child: Text(
                    _steps[_currentStep].message,
                    key: ValueKey(_currentStep),
                    textAlign: TextAlign.center,
                    style: theme.textTheme.bodyLarge?.copyWith(
                      color: theme.colorScheme.onSurface.withOpacity(0.65),
                      fontWeight: FontWeight.w500,
                      height: 1.5,
                    ),
                  ),
                ),

                const SizedBox(height: 24),

                // ── Step dots ─────────────────────────────────────────────
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(_steps.length, (i) {
                    final isActive = i == _currentStep;
                    final isPast = i < _currentStep;
                    return AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      margin: const EdgeInsets.symmetric(horizontal: 4),
                      width: isActive ? 20 : 8,
                      height: 8,
                      decoration: BoxDecoration(
                        color: isActive || isPast
                            ? theme.colorScheme.primary
                            : theme.colorScheme.onSurface.withOpacity(0.15),
                        borderRadius: BorderRadius.circular(4),
                      ),
                    );
                  }),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _LoadingStep {
  final String message;
  final int delay;
  const _LoadingStep({required this.message, required this.delay});
}
