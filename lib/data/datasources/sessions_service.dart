import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:waitwise/data/models/session_model.dart';

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
  } catch (e) {
    print('Error updating session completion: $e');
  }
}
