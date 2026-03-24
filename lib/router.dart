//import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:waitwise/features/onboarding/screens/onboarding_screen.dart';

/*import '../features/onboarding/onboarding_screen.dart';
import '../features/home/context_picker_screen.dart';
import '../features/session/active_session_screen.dart';
import '../features/session/session_complete_screen.dart';
import '../features/dashboard/dashboard_screen.dart';*/

final GoRouter appRouter = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(path: '/', builder: (context, state) => const OnboardingScreen()),
    /*GoRoute(
      path: '/home',
      builder: (context, state) => const ContextPickerScreen(),
    ),
    GoRoute(
      path: '/session',
      builder: (context, state) => const ActiveSessionScreen(),
    ),
    GoRoute(
      path: '/complete',
      builder: (context, state) => const SessionCompleteScreen(),
    ),
    GoRoute(
      path: '/dashboard',
      builder: (context, state) => const DashboardScreen(),
    ),
    GoRoute(
      path: '/backlogs',
      builder: (context, state) => const UserBacklogsScreen(),
    ),*/
  ],
);
