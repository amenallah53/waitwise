// ============================================================
// lib/core/utils/offline_session_store.dart
// ============================================================
// Manages a pool of pre-generated sessions stored in SharedPrefs.
// Used when the device has no internet connection.
// ============================================================

import 'dart:convert';
import 'dart:math';
import 'package:waitwise/core/utils/shared_prefs.dart';
import 'package:waitwise/data/models/session_model.dart';

const _kOfflineSessionsKey = 'offline_sessions';

/// Save a list of sessions to the offline pool.
/// Replaces whatever was there before.
Future<void> saveOfflineSessions(List<SessionModel> sessions) async {
  final encoded = sessions.map((s) => jsonEncode(s.toJson())).toList();
  await prefs.setStringList(_kOfflineSessionsKey, encoded);
}

/// Append a single session to the existing offline pool.
Future<void> appendOfflineSession(SessionModel session) async {
  final existing = _loadRaw();
  existing.add(jsonEncode(session.toJson()));
  await prefs.setStringList(_kOfflineSessionsKey, existing);
}

/// Pop a random session from the pool and return it.
/// Removes it from the pool so it won't be shown again.
/// Returns null if the pool is empty.
SessionModel? popOfflineSession() {
  final raw = _loadRaw();
  if (raw.isEmpty) return null;

  final index = Random().nextInt(raw.length);
  final picked = raw.removeAt(index);
  prefs.setStringList(_kOfflineSessionsKey, raw);

  try {
    final json = jsonDecode(picked) as Map<String, dynamic>;
    return SessionModel.fromJson(json);
  } catch (e) {
    print('⚠️ offline session parse error: $e');
    return null;
  }
}

/// How many sessions are currently in the pool.
int offlineSessionCount() => _loadRaw().length;

/// Clear the entire pool (e.g. on logout).
Future<void> clearOfflineSessions() async {
  await prefs.remove(_kOfflineSessionsKey);
}

List<String> _loadRaw() {
  return List<String>.from(prefs.getStringList(_kOfflineSessionsKey) ?? []);
}
