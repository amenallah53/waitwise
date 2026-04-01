import 'package:flutter_riverpod/flutter_riverpod.dart';

// ─── State ────────────────────────────────────────────────────────────────────

class ReflectionState {
  final String response;
  final bool isDone;

  const ReflectionState({this.response = '', this.isDone = false});

  bool get canSubmit => response.trim().isNotEmpty;

  ReflectionState copyWith({String? response, bool? isDone}) {
    return ReflectionState(
      response: response ?? this.response,
      isDone: isDone ?? this.isDone,
    );
  }
}

// ─── Notifier ─────────────────────────────────────────────────────────────────

class ReflectionNotifier extends StateNotifier<ReflectionState> {
  ReflectionNotifier() : super(const ReflectionState());

  void updateResponse(String value) {
    state = state.copyWith(response: value);
  }

  void markDone() {
    state = state.copyWith(isDone: true);
  }

  void clear() {
    state = const ReflectionState();
  }
}

// ─── Provider ─────────────────────────────────────────────────────────────────

final reflectionProvider =
    StateNotifierProvider<ReflectionNotifier, ReflectionState>(
      (ref) => ReflectionNotifier(),
    );
