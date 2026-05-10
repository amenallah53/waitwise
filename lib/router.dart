import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';
import 'package:waitwise/core/utils/shared_prefs.dart';
import 'package:waitwise/core/widgets/prefetch_loading_screen.dart';
import 'package:waitwise/features/active_session/screens/active_session_screen.dart';
import 'package:waitwise/features/all_sessions/screens/all_sessions_screen.dart';
import 'package:waitwise/features/context_picker/screens/context_picker_screen.dart';
import 'package:waitwise/features/dashboard/screens/dashboard_screen.dart';
import 'package:waitwise/features/onboarding/screens/onboarding_screen.dart';
import 'package:waitwise/features/session_complete/screens/session_complete_screen.dart';
import 'package:waitwise/features/user_backlogs/screens/user_backlogs_screen.dart';

final GoRouter appRouter = GoRouter(
  initialLocation: '/',
  routes: [
    // ── Redirect gate — sync because prefs is already initialized ──────────
    GoRoute(
      path: '/',
      redirect: (context, state) {
        final onboardingDone = prefs.getBool('onboarding_done') ?? false;
        return onboardingDone ? '/home' : '/onboarding';
      },
      builder: (context, state) => const SizedBox.shrink(),
    ),

    GoRoute(
      path: '/onboarding',
      builder: (context, state) => const OnboardingScreen(),
    ),
    GoRoute(
      path: '/home',
      builder: (context, state) => const ContextPickerScreen(),
    ),
    GoRoute(
      path: '/session/active/:id',
      builder: (context, state) => const ActiveSessionScreen(),
    ),
    GoRoute(
      path: '/session/active/:id/complete',
      builder: (context, state) {
        final extra = state.extra as Map<String, dynamic>?;
        final sessionId = state.pathParameters['id'];
        return SessionCompleteScreen(
          sessionId: sessionId,
          durationMinutes: extra?['durationMinutes'] as int? ?? 0,
        );
      },
    ),
    GoRoute(
      path: '/dashboard',
      builder: (context, state) => const DashboardScreen(),
    ),
    /*
    GoRoute(
      path: '/dashboard/session/:id',
      builder: (context, state) => const PastSessionScreen(),
    ),
    */
    GoRoute(
      path: '/dashboard/all-sessions',
      builder: (context, state) => const AllSessionsScreen(),
    ),
    GoRoute(
      path: '/backlogs',
      builder: (context, state) => UserBacklogsScreen(),
    ),
    GoRoute(
      path: '/prefetch-loading',
      builder: (context, state) =>
          PrefetchLoadingScreen(prefetchFuture: state.extra as Future<void>),
    ),
  ],
);
