import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:waitwise/data/models/session_model.dart';

// ─── State ────────────────────────────────────────────────────────────────────

class DashboardState {
  final int totalSessions;
  final int currentStreak;
  final int totalMinutes;
  final double weeklyGrowth; // e.g. 0.12 = +12%
  final bool isPersonalBest;
  //final List<PastSession> recentSessions;
  final List<SessionModel> recentSessions;

  const DashboardState({
    required this.totalSessions,
    required this.currentStreak,
    required this.totalMinutes,
    required this.weeklyGrowth,
    required this.isPersonalBest,
    required this.recentSessions,
  });
}

// ─── Notifier ─────────────────────────────────────────────────────────────────

class DashboardNotifier extends StateNotifier<DashboardState> {
  DashboardNotifier()
    : super(
        DashboardState(
          totalSessions: 42,
          currentStreak: 14,
          totalMinutes: 312,
          weeklyGrowth: 0.12,
          isPersonalBest: true,
          recentSessions: [
            QuizSession(
              id: '1',
              userId: 'user1',
              title: 'Quick Trivia',
              context: 'Waiting for Train',
              durationMinutes: 5,
              createdAt: DateTime.now().subtract(const Duration(hours: 1)),
              aiContent: const QuizContent(questions: []),
            ),

            ReflectionSession(
              id: '2',
              userId: 'user1',
              title: 'Mindful Breathing',
              context: 'Coffee Shop',
              durationMinutes: 3,
              createdAt: DateTime.now().subtract(const Duration(hours: 3)),
              aiContent: const ReflectionContent(prompt: 'Breathe and reflect'),
            ),

            TaskSession(
              id: '3',
              userId: 'user1',
              title: 'Inbox Clearing',
              context: 'Elevator Transit',
              durationMinutes: 8,
              createdAt: DateTime.now().subtract(const Duration(hours: 6)),
              aiContent: const TaskContent(prompt: 'Clear inbox', steps: []),
            ),
          ],
        ),
      );
}

// ─── Provider ─────────────────────────────────────────────────────────────────

final dashboardProvider =
    StateNotifierProvider<DashboardNotifier, DashboardState>(
      (ref) => DashboardNotifier(),
    );
