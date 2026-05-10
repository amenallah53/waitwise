// ============================================================
// lib/core/utils/prefetch_sessions.dart
// ============================================================
// Called after onboarding + after new backlog item is added.
// Triggers n8n to generate sessions and stores them offline.
// ============================================================

import 'dart:convert';
//import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:waitwise/core/utils/offline_session_store.dart';
import 'package:waitwise/data/models/session_model.dart';
import 'package:waitwise/data/models/user_model.dart';

/// Triggers the n8n prefetch workflow.
///
/// [user]            — the current user (interests + backlogs used as context)
/// [requestedCount]  — how many sessions to generate (default 5)
/// [onSuccess]       — called with the sessions once saved (optional)
///
/// This is fire-and-forget safe — all errors are caught internally.
Future<void> prefetchOfflineSessions({
  required UserModel user,
  int requestedCount = 5,
  void Function(List<SessionModel>)? onSuccess,
}) async {
  try {
    //const prefetchUrl = String.fromEnvironment('PREFETCH_WEBHOOK_URL');
    const prefetchUrl =
        "https://amenkalai23.app.n8n.cloud/webhook-test/a414913c-402f-48db-a2d4-b35a4cda9959";
    //final webhookUrl = dotenv.env['PREFETCH_WEBHOOK_URL'] ?? '';
    if (prefetchUrl.isEmpty) {
      print(' PREFETCH_WEBHOOK_URL not set in .env');
      return;
    }

    final backlogContents = user.backlogs.map((b) => b.content).toList();
    final currentPoolSize = offlineSessionCount();

    final response = await http
        .post(
          Uri.parse(prefetchUrl),
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode({
            'user_id': user.id,
            'interests': user.interests,
            'backlog': backlogContents,
            'requested_count': requestedCount,
            'current_pool': currentPoolSize,
          }),
        )
        .timeout(const Duration(seconds: 300));

    if (response.statusCode != 200) {
      print(' prefetch failed: ${response.statusCode}');
      return;
    }

    print(' RAW PREFETCH RESPONSE: ${response.body}');
    final body = jsonDecode(response.body);
    print(' prefetch response body type: ${body.runtimeType}');
    print(' DECODED BODY: $body');

    List<dynamic> rawSessions = [];
    if (body is List) {
      rawSessions = body;
    } else if (body is Map) {
      rawSessions = (body['sessions'] as List?) ?? [];
      // sometimes n8n returns a single object if it's just one item
      if (rawSessions.isEmpty && (body.containsKey('session_type') || body.containsKey('type') || body.containsKey('title'))) {
        rawSessions = [body];
      }
    }

    if (rawSessions.isEmpty) {
      print(' prefetch returned 0 sessions');
      return;
    }

    final sessions = <SessionModel>[];
    for (final raw in rawSessions) {
      try {
        final map = Map<String, dynamic>.from(raw as Map);
        sessions.add(SessionModel.fromJson(map));
      } catch (e) {
        print(' skipping malformed prefetch session: $e');
      }
    }

    if (sessions.isEmpty) return;

    // Replace the pool with fresh sessions
    await saveOfflineSessions(sessions);
    print(' prefetched ${sessions.length} offline sessions');

    onSuccess?.call(sessions);
  } catch (e) {
    // Never crash the caller — prefetch is a background nicety
    print(' prefetchOfflineSessions error: $e');
  }
}

/// Lighter version — called when a new backlog item is added.
/// Generates 1 new session and appends it to the existing pool.
Future<void> prefetchOneSession({
  required UserModel user,
  required String newBacklogContent,
}) async {
  try {
    //final webhookUrl = dotenv.env['PREFETCH_WEBHOOK_URL'] ?? '';
    //const prefetchUrl = String.fromEnvironment('PREFETCH_WEBHOOK_URL');
    const prefetchUrl =
        "https://amenkalai23.app.n8n.cloud/webhook-test/a414913c-402f-48db-a2d4-b35a4cda9959";
    if (prefetchUrl.isEmpty) return;

    final response = await http
        .post(
          Uri.parse(prefetchUrl),
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode({
            'user_id': user.id,
            'interests': user.interests,
            'backlog': [newBacklogContent],
            'requested_count': 1,
            'current_pool': offlineSessionCount(),
          }),
        )
        .timeout(const Duration(seconds: 300));

    if (response.statusCode != 200) return;

    print(' RAW PREFETCH_ONE RESPONSE: ${response.body}');
    final body = jsonDecode(response.body);
    print(' prefetchOne response body type: ${body.runtimeType}');
    print(' DECODED BODY: $body');

    List<dynamic> rawSessions = [];
    if (body is List) {
      rawSessions = body;
    } else if (body is Map) {
      rawSessions = (body['sessions'] as List?) ?? [];
      if (rawSessions.isEmpty && (body.containsKey('session_type') || body.containsKey('type') || body.containsKey('title'))) {
        rawSessions = [body];
      }
    }

    if (rawSessions.isEmpty) return;

    final map = Map<String, dynamic>.from(rawSessions.first as Map);
    final session = SessionModel.fromJson(map);
    await appendOfflineSession(session);
    print(' appended 1 offline session from new backlog');
  } catch (e) {
    print('⚠️ prefetchOneSession error: $e');
  }
}
