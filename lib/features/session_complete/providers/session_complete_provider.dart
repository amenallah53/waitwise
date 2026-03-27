import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// ─── State ───────────────────────────────────────────────
class SessionCompleteState {
  final int minutesSpent;
  final int sessionsThisWeek;
  final int currentStreak;
  final String backlogNote;

  const SessionCompleteState({
    this.minutesSpent = 0,
    this.sessionsThisWeek = 0,
    this.currentStreak = 0,
    this.backlogNote = '',
  });

  SessionCompleteState copyWith({
    int? minutesSpent,
    int? sessionsThisWeek,
    int? currentStreak,
    String? backlogNote,
  }) {
    return SessionCompleteState(
      minutesSpent: minutesSpent ?? this.minutesSpent,
      sessionsThisWeek: sessionsThisWeek ?? this.sessionsThisWeek,
      currentStreak: currentStreak ?? this.currentStreak,
      backlogNote: backlogNote ?? this.backlogNote,
    );
  }
}

// ─── Notifier ────────────────────────────────────────────
class SessionCompleteNotifier extends StateNotifier<SessionCompleteState> {
  SessionCompleteNotifier() : super(const SessionCompleteState());

  // UI controller lives here — disposed with the notifier
  final backlogController = TextEditingController();

  void setSessionData({
    required int minutesSpent,
    required int sessionsThisWeek,
    required int currentStreak,
  }) {
    state = state.copyWith(
      minutesSpent: minutesSpent,
      sessionsThisWeek: sessionsThisWeek,
      currentStreak: currentStreak,
    );
  }

  void updateBacklog(String value) {
    state = state.copyWith(backlogNote: value);
  }

  void submitBacklog() {
    final text = backlogController.text.trim();
    if (text.isEmpty) return;
    state = state.copyWith(backlogNote: text);
    backlogController.clear();
  }

  void reset() {
    state = const SessionCompleteState();
    backlogController.clear();
  }

  @override
  void dispose() {
    backlogController.dispose();
    super.dispose();
  }
}

// ─── Provider ────────────────────────────────────────────
final sessionCompleteProvider =
    StateNotifierProvider<SessionCompleteNotifier, SessionCompleteState>(
      (ref) => SessionCompleteNotifier(),
    );
