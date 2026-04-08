// ============================================================
// lib/core/widgets/prefetch_loading_screen.dart
// ============================================================
// Shown after onboarding "Get Started" while n8n pre-generates
// the offline session pool. Has its own progressive messages
// distinct from the active session loading screen.
// ============================================================

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class PrefetchLoadingScreen extends StatefulWidget {
  /// Called when the prefetch Future completes.
  /// The screen navigates to /home automatically when done.
  final Future<void> prefetchFuture;

  const PrefetchLoadingScreen({super.key, required this.prefetchFuture});

  @override
  State<PrefetchLoadingScreen> createState() => _PrefetchLoadingScreenState();
}

class _PrefetchLoadingScreenState extends State<PrefetchLoadingScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _spinController;

  final List<_Step> _steps = const [
    _Step(message: 'Setting up your space...', delay: 0),
    _Step(message: 'Learning your interests & backlog...', delay: 3),
    _Step(message: 'AI is crafting your first sessions...', delay: 7),
    _Step(message: 'Storing sessions for offline use...', delay: 14),
    _Step(message: 'Almost ready...', delay: 20),
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

    // Schedule message transitions
    for (int i = 1; i < _steps.length; i++) {
      final step = i;
      _timers.add(
        Timer(Duration(seconds: _steps[step].delay), () {
          if (!mounted) return;
          setState(() => _currentStep = step);
        }),
      );
    }

    // When the prefetch completes, navigate to home
    widget.prefetchFuture
        .then((_) {
          if (!mounted) return;
          context.go('/home');
        })
        .catchError((_) {
          // Even on error, move on — offline pool may be empty but app still works
          if (!mounted) return;
          context.go('/home');
        });
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
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 48),
          child: Column(
            children: [
              const Spacer(),

              // ── App name / logo area ────────────────────────────────
              Text(
                'WaitWise',
                style: theme.textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.w800,
                  color: theme.colorScheme.primary,
                  letterSpacing: -0.5,
                ),
              ),

              const SizedBox(height: 48),

              // ── Spinner ─────────────────────────────────────────────
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

              // ── Animated message ────────────────────────────────────
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

              // ── Step dots ───────────────────────────────────────────
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

              const Spacer(),

              // ── Bottom hint ─────────────────────────────────────────
              Text(
                'Preparing your offline sessions\nso you\'re always ready to go.',
                textAlign: TextAlign.center,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurface.withOpacity(0.3),
                  height: 1.6,
                ),
              ),

              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }
}

class _Step {
  final String message;
  final int delay;
  const _Step({required this.message, required this.delay});
}
