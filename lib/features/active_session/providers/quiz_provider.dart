import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:waitwise/data/models/session_model.dart';

// ─── State ────────────────────────────────────────────────────────────────────

class QuizState {
  final QuizSession session;
  final int currentQuestionIndex;
  final int? selectedOptionIndex;
  final bool confirmed; // true after tapping Confirm
  final bool done; // true after tapping Done

  const QuizState({
    required this.session,
    this.currentQuestionIndex = 0,
    this.selectedOptionIndex,
    this.confirmed = false,
    this.done = false,
  });

  QuizQuestion get currentQuestion =>
      session.aiContent.questions[currentQuestionIndex];

  int get totalQuestions => session.aiContent.questions.length;
  bool get isLastQuestion => currentQuestionIndex == totalQuestions - 1;
  bool get hasSelection => selectedOptionIndex != null;

  bool get isCorrect =>
      confirmed && selectedOptionIndex == currentQuestion.correctIndex;

  QuizState copyWith({
    int? currentQuestionIndex,
    int? selectedOptionIndex,
    bool clearSelection = false,
    bool? confirmed,
    bool? done,
  }) {
    return QuizState(
      session: session,
      currentQuestionIndex: currentQuestionIndex ?? this.currentQuestionIndex,
      selectedOptionIndex: clearSelection
          ? null
          : selectedOptionIndex ?? this.selectedOptionIndex,
      confirmed: confirmed ?? this.confirmed,
      done: done ?? this.done,
    );
  }
}

// ─── Notifier ─────────────────────────────────────────────────────────────────

class QuizNotifier extends StateNotifier<QuizState> {
  QuizNotifier(QuizSession session) : super(QuizState(session: session));

  void selectOption(int index) {
    if (state.confirmed) return; // locked after confirm
    state = state.copyWith(selectedOptionIndex: index);
  }

  void confirm() {
    if (!state.hasSelection) return;
    state = state.copyWith(confirmed: true);
  }

  void next() {
    if (state.isLastQuestion) {
      state = state.copyWith(done: true);
      return;
    }
    state = state.copyWith(
      currentQuestionIndex: state.currentQuestionIndex + 1,
      clearSelection: true,
      confirmed: false,
    );
  }

  void skip() {
    if (state.isLastQuestion) {
      state = state.copyWith(done: true);
      return;
    }
    state = state.copyWith(
      currentQuestionIndex: state.currentQuestionIndex + 1,
      clearSelection: true,
      confirmed: false,
    );
  }
}

// ─── Provider ─────────────────────────────────────────────────────────────────

// family so each QuizSession gets its own isolated provider instance
final quizProvider =
    StateNotifierProvider.family<QuizNotifier, QuizState, QuizSession>(
      (ref, session) => QuizNotifier(session),
    );
