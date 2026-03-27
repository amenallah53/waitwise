import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ReflectionState {
  final String response;
  final bool completed;
  final int remainingSeconds; // for timer

  const ReflectionState({
    this.response = '',
    this.completed = false,
    this.remainingSeconds = 300, // default 5 minutes
  });

  ReflectionState copyWith({
    String? response,
    bool? completed,
    int? remainingSeconds,
  }) {
    return ReflectionState(
      response: response ?? this.response,
      completed: completed ?? this.completed,
      remainingSeconds: remainingSeconds ?? this.remainingSeconds,
    );
  }
}

class ReflectionNotifier extends StateNotifier<ReflectionState> {
  Timer? _timer;

  ReflectionNotifier() : super(const ReflectionState()) {
    startTimer();
  }

  void startTimer() {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (state.remainingSeconds > 0) {
        state = state.copyWith(remainingSeconds: state.remainingSeconds - 1);
      } else {
        timer.cancel();
      }
    });
  }

  void updateResponse(String value) {
    state = state.copyWith(response: value);
  }

  void markDone() {
    if (state.response.isNotEmpty || state.remainingSeconds == 0) {
      state = state.copyWith(completed: true);
      _timer?.cancel();
    }
  }

  void clear() {
    _timer?.cancel();
    state = const ReflectionState();
    startTimer();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
}

final reflectionProvider =
    StateNotifierProvider<ReflectionNotifier, ReflectionState>(
      (ref) => ReflectionNotifier(),
    );
