import 'package:flutter_riverpod/flutter_riverpod.dart';

// ─── State model ──────────────────────────────────────────────────────────────

class QuizState {
  final int? selectedOption;
  final int currentQuestion;
  final int totalQuestions;

  const QuizState({
    this.selectedOption,
    this.currentQuestion = 1,
    this.totalQuestions = 5,
  });

  double get progress => currentQuestion / totalQuestions;

  QuizState copyWith({
    int? selectedOption,
    bool clearSelection = false,
    int? currentQuestion,
  }) {
    return QuizState(
      selectedOption: clearSelection
          ? null
          : selectedOption ?? this.selectedOption,
      currentQuestion: currentQuestion ?? this.currentQuestion,
      totalQuestions: totalQuestions,
    );
  }
}

// ─── Notifier ─────────────────────────────────────────────────────────────────

class QuizNotifier extends StateNotifier<QuizState> {
  QuizNotifier() : super(const QuizState());

  void selectOption(int index) {
    state = state.copyWith(selectedOption: index);
  }

  void nextQuestion() {
    if (state.currentQuestion < state.totalQuestions) {
      state = state.copyWith(
        currentQuestion: state.currentQuestion + 1,
        clearSelection: true,
      );
    }
  }
}

// ─── Provider ─────────────────────────────────────────────────────────────────

final quizProvider = StateNotifierProvider<QuizNotifier, QuizState>(
  (ref) => QuizNotifier(),
);
