import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';

// ─── Mood enum ────────────────────────────────────────────────────────────────

enum UserMood {
  calm('Calm', Icons.self_improvement),
  busy('Busy', Icons.flash_on),
  bored('Bored', Icons.hourglass_empty),
  tired('Tired', Icons.nightlight_round),
  focused('Focused', Icons.center_focus_strong),
  anxious('Anxious', Icons.warning_amber_rounded),
  happy('Happy', Icons.sentiment_satisfied_alt);

  final String label;
  final IconData icon;

  const UserMood(this.label, this.icon);
}

// ─── State ────────────────────────────────────────────────────────────────────

class ContextPickerState {
  final String context;
  final UserMood? selectedMood;
  final int durationMinutes;

  const ContextPickerState({
    this.context = '',
    this.selectedMood,
    this.durationMinutes = 5,
  });

  bool get isReady => context.trim().isNotEmpty && selectedMood != null;

  ContextPickerState copyWith({
    String? context,
    UserMood? selectedMood,
    bool clearMood = false,
    int? durationMinutes,
  }) {
    return ContextPickerState(
      context: context ?? this.context,
      selectedMood: clearMood ? null : selectedMood ?? this.selectedMood,
      durationMinutes: durationMinutes ?? this.durationMinutes,
    );
  }
}

// ─── Notifier ─────────────────────────────────────────────────────────────────

class ContextPickerNotifier extends StateNotifier<ContextPickerState> {
  ContextPickerNotifier() : super(const ContextPickerState());

  void reset() {
    state = const ContextPickerState();
  }

  void setContext(String value) {
    state = state.copyWith(context: value);
  }

  void selectMood(UserMood mood) {
    if (state.selectedMood == mood) {
      state = state.copyWith(clearMood: true);
    } else {
      state = state.copyWith(selectedMood: mood);
    }
  }

  void setDuration(int minutes) {
    state = state.copyWith(durationMinutes: minutes);
  }
}

// ─── Provider ─────────────────────────────────────────────────────────────────

final contextPickerProvider =
    StateNotifierProvider<ContextPickerNotifier, ContextPickerState>(
      (ref) => ContextPickerNotifier(),
    );
