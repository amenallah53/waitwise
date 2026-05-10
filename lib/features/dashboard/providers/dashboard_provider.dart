import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:waitwise/core/utils/current_user.dart';
import 'package:waitwise/data/datasources/sessions_service.dart';
import 'package:waitwise/data/models/session_model.dart';
import 'package:waitwise/data/models/user_model.dart';
import 'package:waitwise/data/datasources/users_service.dart';

// ─── State ────────────────────────────────────────────────────────────────────

class DashboardState {
  final int totalSessions;
  final int currentStreak;
  final int totalMinutes;
  final double weeklyGrowth; // e.g. 0.12 = +12%
  final bool isPersonalBest;
  //final List<PastSession> recentSessions;
  final List<SessionModel> recentSessions;

  final bool isLoading;
  final String? error;

  const DashboardState({
    required this.totalSessions,
    required this.currentStreak,
    required this.totalMinutes,
    required this.weeklyGrowth,
    required this.isPersonalBest,
    required this.recentSessions,
    this.isLoading = false,
    this.error,
  });

  DashboardState copyWith({
    int? totalSessions,
    int? currentStreak,
    int? totalMinutes,
    double? weeklyGrowth,
    bool? isPersonalBest,
    bool? isLoading,
    String? error,
    List<SessionModel>? recentSessions,
  }) => DashboardState(
    totalSessions: totalSessions ?? this.totalSessions,
    currentStreak: currentStreak ?? this.currentStreak,
    totalMinutes: totalMinutes ?? this.totalMinutes,
    weeklyGrowth: weeklyGrowth ?? this.weeklyGrowth,
    isPersonalBest: isPersonalBest ?? this.isPersonalBest,
    recentSessions: recentSessions ?? this.recentSessions,
    isLoading: isLoading ?? this.isLoading,
    error: error,
  );
}

// ─── Notifier ─────────────────────────────────────────────────────────────────

/*class DashboardNotifier extends StateNotifier<DashboardState> {
  DashboardNotifier()
    : super(isLoading: isLoading ?? this.isLoading, error: error);
}*/

// ─── Notifier ─────────────────────────────────────────────────────────────────

class DashboardNotifier extends StateNotifier<DashboardState> {
  DashboardNotifier()
    : super(
        DashboardState(
          totalSessions: 0,
          currentStreak: 0,
          totalMinutes: 0,
          weeklyGrowth: 0.12,
          isPersonalBest: false,
          recentSessions: [],
        ),
      );

  // ── Load ──────────────────────────────────────────────────

  /// Call this once when the screen mounts, passing the current user's id
  Future<void> load(String userId) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      // Fetch latest sessions
      final rows = await fetchSessions(userId, limit: 5);
      
      // Fetch latest user data from DB for accurate stats
      final user = await fetchUser(userId);
      final currentSessionsList = rows.toList();

      if (user != null) {
        state = state.copyWith(
          isLoading: false, 
          recentSessions: currentSessionsList,
          totalSessions: user.sessionsCompleted,
          currentStreak: user.currentStreak,
          totalMinutes: user.timesReclaimed,
          isPersonalBest: user.currentStreak >= user.bestStreak && user.currentStreak > 0,
        );
      } else {
        // Fallback to local if fetch failed or user not found
        final currentUser = getCurrentUser();
        state = state.copyWith(
          isLoading: false, 
          recentSessions: currentSessionsList,
          totalSessions: currentUser?.sessionsCompleted ?? 0,
          currentStreak: currentUser?.currentStreak ?? 0,
          totalMinutes: currentUser?.timesReclaimed ?? 0,
          isPersonalBest: (currentUser?.currentStreak ?? 0) >= (currentUser?.bestStreak ?? 0) && (currentUser?.currentStreak ?? 0) > 0,
        );
      }
      print('Loaded ${rows.length} sessions for user $userId');
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }
}

// ─── Provider ─────────────────────────────────────────────────────────────────

final dashboardProvider =
    StateNotifierProvider<DashboardNotifier, DashboardState>((ref) {
      final notifier = DashboardNotifier();

      UserModel? currentUser = getCurrentUser();

      if (currentUser?.id != null) {
        notifier.load(currentUser!.id!);
      }

      return notifier;
    });
