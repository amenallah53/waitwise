import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:waitwise/data/models/session_model.dart';
import 'package:waitwise/data/datasources/users_service.dart';
import 'package:waitwise/core/utils/current_user.dart';

final _db = Supabase.instance.client;

/// Fetch all sessions for a user, newest first
Future<List<SessionModel>> fetchSessions(String userId, {int? limit}) async {
  try {
    var query = _db
        .from('sessions')
        .select()
        .eq('user_id', userId)
        .order('created_at', ascending: false);

    if (limit != null) {
      query = query.limit(limit);
    }

    final rows = await query;

    return (rows as List)
        .map((e) => SessionModel.fromJson(e as Map<String, dynamic>))
        .toList();
  } catch (e, stack) {
    // log properly instead of print
    print('fetchSessions error: $e');
    print(stack);
    return [];
  }
}

/// update the completion status of a session
Future<void> updateSessionCompletion(String sessionId, bool completed) async {
  try {
    await _db
        .from('sessions')
        .update({'completed': completed})
        .eq('id', sessionId);
    print('Session $sessionId marked as completed: $completed');

    if (completed) {
      final sessionRow = await _db.from('sessions').select().eq('id', sessionId).maybeSingle();
      if (sessionRow != null) {
        final session = SessionModel.fromJson(sessionRow);
        final userId = session.userId;
        final duration = session.durationMinutes;

        final user = await fetchUser(userId);
        if (user != null) {
          final newSessions = user.sessionsCompleted + 1;
          final newMinutes = user.timesReclaimed + duration;
          final newStreak = user.currentStreak + 1;
          final newBestStreak = newStreak > user.bestStreak ? newStreak : user.bestStreak;

          await updateUserStats(
            userId: userId,
            sessionsCompleted: newSessions,
            currentStreak: newStreak,
            bestStreak: newBestStreak,
            timesReclaimed: newMinutes,
          );

          final localUser = getCurrentUser();
          if (localUser != null && localUser.id == userId) {
            saveCurrentUser(localUser.copyWith(
              sessionsCompleted: newSessions,
              currentStreak: newStreak,
              bestStreak: newBestStreak,
              timesReclaimed: newMinutes,
            ));
          }
        }
      }
    }
  } catch (e) {
    print('Error updating session completion: $e');
  }
}
