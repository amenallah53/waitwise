import 'package:flutter_riverpod/flutter_riverpod.dart';

// ─── State model ─────────────────────────────────────────────────────────────

class OnboardingState {
  final String name;
  final String thoughts;
  final Set<String> selectedInterests;

  const OnboardingState({
    this.name = '',
    this.thoughts = '',
    this.selectedInterests = const {},
  });

  OnboardingState copyWith({
    String? name,
    String? thoughts,
    Set<String>? selectedInterests,
  }) {
    return OnboardingState(
      name: name ?? this.name,
      thoughts: thoughts ?? this.thoughts,
      selectedInterests: selectedInterests ?? this.selectedInterests,
    );
  }
}

// ─── Notifier ─────────────────────────────────────────────────────────────────

class OnboardingNotifier extends StateNotifier<OnboardingState> {
  OnboardingNotifier() : super(const OnboardingState());

  void setName(String value) {
    state = state.copyWith(name: value);
  }

  void setThoughts(String value) {
    state = state.copyWith(thoughts: value);
  }

  void toggleInterest(String interest) {
    final updated = Set<String>.from(state.selectedInterests);
    if (updated.contains(interest)) {
      updated.remove(interest);
    } else {
      updated.add(interest);
    }
    state = state.copyWith(selectedInterests: updated);
  }
}

// ─── Provider ─────────────────────────────────────────────────────────────────

final onboardingProvider =
    StateNotifierProvider<OnboardingNotifier, OnboardingState>(
      (ref) => OnboardingNotifier(),
    );
