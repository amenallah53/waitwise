// ============================================================
// lib/features/active_session/screens/active_session_screen.dart
// ============================================================

import 'dart:math';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:waitwise/core/constants/fallback_sessions.dart';
import 'package:waitwise/core/utils/fetch_session_from_n8n.dart';
import 'package:waitwise/core/widgets/session_loading_screen.dart';
import 'package:waitwise/data/models/session_model.dart';
import 'package:waitwise/features/active_session/screens/quiz/quiz_screen.dart';
import 'package:waitwise/features/active_session/screens/reflection/reflection_screen.dart';
import 'package:waitwise/features/active_session/screens/task/task_screen.dart';

class ActiveSessionScreen extends StatefulWidget {
  const ActiveSessionScreen({super.key});

  @override
  State<ActiveSessionScreen> createState() => _ActiveSessionScreenState();
}

class _ActiveSessionScreenState extends State<ActiveSessionScreen> {
  SessionModel? _session;
  bool _isLoading = true;
  bool _hasRun = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_hasRun) {
      _hasRun = true;
      _fetchSession();
    }
  }

  Future<void> _fetchSession() async {
    final extra = GoRouterState.of(context).extra as Map<String, dynamic>?;

    final userId = extra?['user_id'] ?? '';
    final userContext = extra?['context'] ?? '';
    final mood = extra?['mood'] ?? '';
    final duration = extra?['duration'] ?? 5;

    try {
      final session = await fetchSessionFromN8n(
        userId: userId,
        context: userContext,
        mood: mood,
        duration: duration,
      );

      if (!mounted) return;
      setState(() {
        _session = session;
        _isLoading = false;
      });
    } catch (e, stack) {
      print('❌ n8n failed — using fallback session: $e');
      print(stack);

      final fallback = _pickFallbackSession(
        userId: userId,
        userContext: userContext,
        mood: mood,
        duration: duration is int ? duration : 5,
      );

      if (!mounted) return;
      setState(() {
        _session = fallback;
        _isLoading = false;
      });
    }
  }

  // ─────────────────────────────────────────
  // FALLBACK SESSION POOL
  // ─────────────────────────────────────────

  SessionModel _pickFallbackSession({
    required String userId,
    required String userContext,
    required String mood,
    required int duration,
  }) {
    final now = DateTime.now();

    final poolOfFallbackSessions = loadFallbackSessions(
      userId,
      userContext,
      mood,
      duration,
      now,
    );

    return poolOfFallbackSessions[Random().nextInt(
      poolOfFallbackSessions.length,
    )];
  }

  // ─────────────────────────────────────────
  // BUILD
  // ─────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const SessionLoadingScreen();
    }

    return switch (_session!) {
      ReflectionSession s => ReflectionScreen(session: s),
      QuizSession s => QuizScreen(session: s),
      TaskSession s => TasksScreen(session: s),
      _ => const SessionLoadingScreen(),
    };
  }
}
