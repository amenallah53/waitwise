import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:waitwise/data/models/session_model.dart';

final _db = Supabase.instance.client;

/// Fetch all sessions for a user, newest first
Future<List<SessionModel>> fetchSessions(String userId) async {
  final rows = await _db
      .from('sessions')
      .select()
      .eq('user_id', userId)
      .order('created_at', ascending: false)
      .limit(5);

  final listOfSessions = (rows as List)
      .map((r) => SessionModel.fromJson(r))
      .toList();

  for (final session in listOfSessions) {
    print('Session all :  $session');
  }

  return listOfSessions;
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
