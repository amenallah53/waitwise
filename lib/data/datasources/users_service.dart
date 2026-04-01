// ============================================================
// lib/data/datasources/users_service.dart
// ============================================================

import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:waitwise/data/models/user_model.dart';

final _db = Supabase.instance.client;

// ─────────────────────────────────────────
// USER CRUD
// ─────────────────────────────────────────

/// Insert a new user row + all their initial backlog items
Future<void> saveUserToDb(UserModel user) async {
  await _db.from('users').insert({
    if (user.id != null) 'id': user.id,
    'name': user.name,
    'interests': user.interests,
    'created_at': user.createdAt.toIso8601String(),
    'sessions_completed': user.sessionsCompleted,
    'current_streak': user.currentStreak,
    'best_streak': user.bestStreak,
    'times_reclaimed': user.timesReclaimed,
  });

  for (final backlog in user.backlogs) {
    await _db.from('user_backlogs').insert({
      'user_id': user.id,
      'content': backlog.content,
      'date': backlog.date.toIso8601String(),
    });
  }
}

/// Fetch a single user by id (without backlogs)
Future<UserModel?> fetchUser(String userId) async {
  final row = await _db.from('users').select().eq('id', userId).maybeSingle();

  if (row == null) return null;
  return UserModel.fromJson(row);
}

/// Fetch user + their backlogs in one call
Future<UserModel?> fetchUserWithBacklogs(String userId) async {
  final row = await _db.from('users').select().eq('id', userId).maybeSingle();

  if (row == null) return null;

  final backlogs = await fetchUserBacklogs(userId);
  return UserModel.fromJson(
    row,
    backlogRows: backlogs.map((b) => b.toJson()).toList(),
  );
}

/// Update user stats after a session completes
Future<void> updateUserStats({
  required String userId,
  required int sessionsCompleted,
  required int currentStreak,
  required int bestStreak,
  required int timesReclaimed,
}) async {
  await _db
      .from('users')
      .update({
        'sessions_completed': sessionsCompleted,
        'current_streak': currentStreak,
        'best_streak': bestStreak,
        'times_reclaimed': timesReclaimed,
      })
      .eq('id', userId);
}

/// Update user interests
Future<void> updateUserInterests(String userId, List<String> interests) async {
  await _db.from('users').update({'interests': interests}).eq('id', userId);
}

/// Delete a user (cascades to sessions + backlogs via FK)
Future<void> deleteUser(String userId) async {
  await _db.from('users').delete().eq('id', userId);
}

// ─────────────────────────────────────────
// BACKLOG CRUD
// ─────────────────────────────────────────

/// Insert a single backlog item
Future<UserBacklog> addBacklogItem(String userId, String content) async {
  final row = await _db
      .from('user_backlogs')
      .insert({
        'user_id': userId,
        'content': content,
        'date': DateTime.now().toIso8601String(),
      })
      .select()
      .single();

  return UserBacklog.fromJson(row);
}

/// Fetch all backlog items for a user, newest first
Future<List<UserBacklog>> fetchUserBacklogs(String userId) async {
  final rows = await _db
      .from('user_backlogs')
      .select()
      .eq('user_id', userId)
      .order('date', ascending: false);

  return (rows as List)
      .map((r) => UserBacklog.fromJson(r as Map<String, dynamic>))
      .toList();
}

/*Future<void> updateBacklogItem(String backlogId, String newContent) async {
  print('Update backlog: $backlogId');
  final res = await _db
      .from('user_backlogs')
      .update({'content': newContent})
      .eq('id', backlogId)
      .select();

  if (res.isEmpty) {
    throw Exception('Update failed: no rows affected');
  }
  print('Update response: $res');
}*/

Future<void> updateBacklogItem(String backlogId, String newContent) async {
  try {
    print('Updating backlog: $backlogId');

    print('Trying to update ID: $backlogId');

    final check = await _db.from('user_backlogs').select().eq('id', backlogId);

    print('AUTH USER: ${_db.auth.currentUser?.id}');
    //print('ROW USER: ${check.first['user_id']}');

    print('Matching rows BEFORE update: $check');

    final res = await _db
        .from('user_backlogs')
        .update({'content': newContent})
        .eq('id', backlogId)
        .select();

    print('Update response: $res');
  } catch (e, stack) {
    print('UPDATE ERROR: $e');
    print(stack);
  }
}

/// Delete a single backlog item
/*Future<void> deleteBacklogItem(String backlogId) async {
  await _db.from('user_backlogs').delete().eq('id', backlogId);
}*/

Future<void> deleteBacklogItem(String backlogId) async {
  print('Deleting backlog: $backlogId');

  final res = await _db
      .from('user_backlogs')
      .delete()
      .eq('id', backlogId)
      .select();

  print('Delete response: $res');
}

/// Delete all backlog items for a user
Future<void> clearUserBacklogs(String userId) async {
  await _db.from('user_backlogs').delete().eq('user_id', userId);
}
