//import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:waitwise/features/active_session/screens/active_session_screen.dart';
import 'package:waitwise/features/context_picker/screens/context_picker_screen.dart';
import 'package:waitwise/features/dashboard/screens/dashboard_screen.dart';
import 'package:waitwise/features/onboarding/screens/onboarding_screen.dart';
import 'package:waitwise/features/session_complete/screens/session_complete_screen.dart';
import 'package:waitwise/features/user_backlogs/screens/user_backlogs_screen.dart';

final GoRouter appRouter = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(path: '/', builder: (context, state) => const OnboardingScreen()),
    GoRoute(
      path: '/home',
      builder: (context, state) => const ContextPickerScreen(),
    ),
    GoRoute(
      path: '/session',
      builder: (context, state) => const ActiveSessionScreen(),
    ),
    GoRoute(
      path: '/session/complete',
      builder: (context, state) => const SessionCompleteScreen(),
    ),
    GoRoute(
      path: '/dashboard',
      builder: (context, state) => const DashboardScreen(),
    ),
    GoRoute(
      path: '/backlogs',
      builder: (context, state) => const UserBacklogsScreen(),
    ),
  ],
);
