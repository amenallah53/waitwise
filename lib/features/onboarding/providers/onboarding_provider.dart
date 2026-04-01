import 'package:flutter_riverpod/flutter_riverpod.dart';

// ─── State model ─────────────────────────────────────────────────────────────

class OnboardingState {
  final String name;
  final String thoughts;
  final Set<String> selectedInterests;
  final List<String> customInterests;

  bool get isReady =>
      name.trim().isNotEmpty &&
      thoughts.trim().isNotEmpty &&
      selectedInterests.isNotEmpty;

  const OnboardingState({
    this.name = '',
    this.thoughts = '',
    this.selectedInterests = const {},
    this.customInterests = const [],
  });

  OnboardingState copyWith({
    String? name,
    String? thoughts,
    Set<String>? selectedInterests,
    List<String>? customInterests,
  }) {
    return OnboardingState(
      name: name ?? this.name,
      thoughts: thoughts ?? this.thoughts,
      selectedInterests: selectedInterests ?? this.selectedInterests,
      customInterests: customInterests ?? this.customInterests,
    );
  }
}

// ─── Notifier ────────────────────────────────────────────────────────────────

class OnboardingNotifier extends StateNotifier<OnboardingState> {
  OnboardingNotifier() : super(const OnboardingState());

  // ── Name ─────────────────────────────────────────
  void setName(String value) {
    state = state.copyWith(name: value);
  }

  // ── Thoughts ─────────────────────────────────────
  void setThoughts(String value) {
    state = state.copyWith(thoughts: value);
  }

  // ── Toggle predefined interests ───────────────────
  void toggleInterest(String interest) {
    final updated = Set<String>.from(state.selectedInterests);

    if (updated.contains(interest)) {
      updated.remove(interest);
    } else {
      updated.add(interest);
    }

    state = state.copyWith(selectedInterests: updated);
  }

  // ── Add custom interest (from "Other") ────────────
  void addCustomInterest(String interest) {
    final trimmed = interest.trim();

    if (trimmed.isEmpty) return;

    // prevent duplicates
    if (state.customInterests.contains(trimmed)) return;

    final updatedCustom = List<String>.from(state.customInterests)
      ..add(trimmed);

    final updatedSelected = Set<String>.from(state.selectedInterests)
      ..add(trimmed);

    state = state.copyWith(
      customInterests: updatedCustom,
      selectedInterests: updatedSelected,
    );
  }

  // ── Optional: remove custom interest (future use) ─
  void removeCustomInterest(String interest) {
    final updatedCustom = List<String>.from(state.customInterests)
      ..remove(interest);

    final updatedSelected = Set<String>.from(state.selectedInterests)
      ..remove(interest);

    state = state.copyWith(
      customInterests: updatedCustom,
      selectedInterests: updatedSelected,
    );
  }

  // ── Optional: reset everything ────────────────────
  void reset() {
    state = const OnboardingState();
  }
}

// ─── Provider ────────────────────────────────────────────────────────────────

final onboardingProvider =
    StateNotifierProvider<OnboardingNotifier, OnboardingState>(
      (ref) => OnboardingNotifier(),
    );
