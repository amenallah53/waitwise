// ============================================================
// lib/features/all_sessions/providers/all_sessions_provider.dart
// ============================================================

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:waitwise/core/utils/current_user.dart';
import 'package:waitwise/data/datasources/sessions_service.dart';
import 'package:waitwise/data/models/session_model.dart';

// ─────────────────────────────────────────
// FILTER ENUM
// ─────────────────────────────────────────

enum SessionFilter { all, reflection, task, quiz }

extension SessionFilterX on SessionFilter {
  String get label {
    switch (this) {
      case SessionFilter.all:
        return 'All';
      case SessionFilter.reflection:
        return 'Reflection';
      case SessionFilter.task:
        return 'Task';
      case SessionFilter.quiz:
        return 'Quiz';
    }
  }

  SessionType? get sessionType {
    switch (this) {
      case SessionFilter.all:
        return null;
      case SessionFilter.reflection:
        return SessionType.reflection;
      case SessionFilter.task:
        return SessionType.task;
      case SessionFilter.quiz:
        return SessionType.quiz;
    }
  }
}

// ─────────────────────────────────────────
// STATE
// ─────────────────────────────────────────

class AllSessionsState {
  final List<SessionModel> allSessions; // raw from DB
  final bool isLoading;
  final String? error;
  final SessionFilter activeFilter;
  final String searchQuery;

  const AllSessionsState({
    this.allSessions = const [],
    this.isLoading = true,
    this.error,
    this.activeFilter = SessionFilter.all,
    this.searchQuery = '',
  });

  // Derived — what the UI actually renders
  List<SessionModel> get filtered {
    var list = allSessions;

    // Apply type filter
    final type = activeFilter.sessionType;
    if (type != null) {
      list = list.where((s) => s.sessionType == type).toList();
    }

    // Apply search
    final q = searchQuery.trim().toLowerCase();
    if (q.isNotEmpty) {
      list = list.where((s) {
        final title = (s.title ?? '').toLowerCase();
        final context = (s.context ?? '').toLowerCase();
        return title.contains(q) || context.contains(q);
      }).toList();
    }

    return list;
  }

  // Count per type (for filter badges)
  int countFor(SessionFilter f) {
    if (f == SessionFilter.all) return allSessions.length;
    return allSessions.where((s) => s.sessionType == f.sessionType).length;
  }

  AllSessionsState copyWith({
    List<SessionModel>? allSessions,
    bool? isLoading,
    String? error,
    SessionFilter? activeFilter,
    String? searchQuery,
  }) => AllSessionsState(
    allSessions: allSessions ?? this.allSessions,
    isLoading: isLoading ?? this.isLoading,
    error: error,
    activeFilter: activeFilter ?? this.activeFilter,
    searchQuery: searchQuery ?? this.searchQuery,
  );
}

// ─────────────────────────────────────────
// NOTIFIER
// ─────────────────────────────────────────

class AllSessionsNotifier extends StateNotifier<AllSessionsState> {
  AllSessionsNotifier() : super(const AllSessionsState());

  Future<void> load(String userId) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final rows = await fetchSessions(userId);
      state = state.copyWith(isLoading: false, allSessions: rows);
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  void setFilter(SessionFilter filter) {
    state = state.copyWith(activeFilter: filter);
  }

  void setSearch(String query) {
    state = state.copyWith(searchQuery: query);
  }

  void clearSearch() {
    state = state.copyWith(searchQuery: '');
  }
}

// ─────────────────────────────────────────
// PROVIDER
// ─────────────────────────────────────────

final allSessionsProvider =
    StateNotifierProvider<AllSessionsNotifier, AllSessionsState>((ref) {
      final notifier = AllSessionsNotifier();
      final currentUser = getCurrentUser();
      final userId = currentUser?.id;
      if (userId != null) notifier.load(userId);
      return notifier;
    });
