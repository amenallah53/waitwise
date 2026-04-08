// ============================================================
// lib/features/backlog/providers/backlog_provider.dart
// ============================================================

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:waitwise/core/utils/current_user.dart';
import 'package:waitwise/core/utils/prefetch_sessions.dart';
import 'package:waitwise/data/datasources/users_service.dart';
import 'package:waitwise/data/models/user_model.dart';

// ─────────────────────────────────────────
// MODEL
// ─────────────────────────────────────────

/// UI-facing backlog item — wraps UserBacklog with a timeAgo helper
class BacklogItem {
  final String id;
  final String userId;
  final String text;
  final DateTime addedAt;

  const BacklogItem({
    required this.id,
    required this.userId,
    required this.text,
    required this.addedAt,
  });

  /// Build from the DB model
  factory BacklogItem.fromUserBacklog(UserBacklog b) => BacklogItem(
    id: b.id ?? '',
    userId: b.userId,
    text: b.content,
    addedAt: b.date,
  );

  BacklogItem copyWith({String? text}) => BacklogItem(
    id: id,
    userId: userId,
    text: text ?? this.text,
    addedAt: addedAt,
  );

  String get timeAgo {
    final diff = DateTime.now().difference(addedAt);
    if (diff.inMinutes < 60) return '${diff.inMinutes}m ago';
    if (diff.inHours < 24) return '${diff.inHours}h ago';
    if (diff.inDays == 1) return 'Yesterday';
    return '${diff.inDays} days ago';
  }
}

// ─────────────────────────────────────────
// STATE
// ─────────────────────────────────────────

class BacklogState {
  final List<BacklogItem> items;
  final bool isLoading;
  final String? error;

  const BacklogState({
    this.items = const [],
    this.isLoading = false,
    this.error,
  });

  BacklogState copyWith({
    List<BacklogItem>? items,
    bool? isLoading,
    String? error,
  }) => BacklogState(
    items: items ?? this.items,
    isLoading: isLoading ?? this.isLoading,
    error: error,
  );
}

// ─────────────────────────────────────────
// NOTIFIER
// ─────────────────────────────────────────

class BacklogNotifier extends StateNotifier<BacklogState> {
  BacklogNotifier() : super(const BacklogState());

  // ── Load ──────────────────────────────────────────────────

  /// Call this once when the screen mounts, passing the current user's id
  Future<void> load(String userId) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final rows = await fetchUserBacklogs(userId);
      state = state.copyWith(
        isLoading: false,
        items: rows.map(BacklogItem.fromUserBacklog).toList(),
      );
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  // ── Create ────────────────────────────────────────────────

  /// Add a new item — saves to Supabase and prepends to local list
  Future<void> addItem(String userId, String text) async {
    if (text.trim().isEmpty) return;
    try {
      final saved = await addBacklogItem(userId, text.trim());
      final item = BacklogItem.fromUserBacklog(saved);
      state = state.copyWith(items: [item, ...state.items]);
      // ✅ Fire and forget — doesn't block the UI
      final user = getCurrentUser();
      if (user != null) {
        prefetchOneSession(user: user, newBacklogContent: text.trim());
      }
    } catch (e) {
      state = state.copyWith(error: e.toString());
    }
  }

  // ── Update ────────────────────────────────────────────────

  /// Edit the text of an existing item — updates Supabase and local list
  Future<void> editItem(String backlogId, String newText) async {
    if (newText.trim().isEmpty) return;
    try {
      await updateBacklogItem(backlogId, newText.trim());
      state = state.copyWith(
        items: state.items
            .map(
              (i) => i.id == backlogId ? i.copyWith(text: newText.trim()) : i,
            )
            .toList(),
      );
    } catch (e) {
      state = state.copyWith(error: e.toString());
    }
  }

  // ── Delete ────────────────────────────────────────────────

  /// Delete a single item — removes from Supabase and local list
  Future<void> deleteItem(String backlogId) async {
    try {
      await deleteBacklogItem(backlogId);
      state = state.copyWith(
        items: state.items.where((i) => i.id != backlogId).toList(),
      );
    } catch (e) {
      state = state.copyWith(error: e.toString());
    }
  }

  /// Delete all items for a user
  Future<void> clearAll(String userId) async {
    try {
      await clearUserBacklogs(userId);
      state = state.copyWith(items: []);
    } catch (e) {
      state = state.copyWith(error: e.toString());
    }
  }

  // ── Optimistic helpers ────────────────────────────────────

  /// Clear any error from state (e.g. after showing a snackbar)
  void clearError() => state = state.copyWith(error: null);
}

// ─────────────────────────────────────────
// PROVIDER
// ─────────────────────────────────────────

/*final backlogProvider = StateNotifierProvider<BacklogNotifier, BacklogState>(
  (ref) => BacklogNotifier(),
);*/

final backlogProvider = StateNotifierProvider<BacklogNotifier, BacklogState>((
  ref,
) {
  final notifier = BacklogNotifier();

  UserModel? currentUser = getCurrentUser();

  // Trigger load immediately
  final userId = currentUser?.id; // however you get it
  notifier.load(userId!);

  return notifier;
});
