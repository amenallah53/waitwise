import 'package:flutter_riverpod/flutter_riverpod.dart';

// ─── Model ────────────────────────────────────────────────────────────────────

class BacklogItem {
  final String id;
  final String text;
  final DateTime addedAt;

  const BacklogItem({
    required this.id,
    required this.text,
    required this.addedAt,
  });

  BacklogItem copyWith({String? text}) =>
      BacklogItem(id: id, text: text ?? this.text, addedAt: addedAt);

  String get timeAgo {
    final diff = DateTime.now().difference(addedAt);
    if (diff.inMinutes < 60) return '${diff.inMinutes}m ago';
    if (diff.inHours < 24) return '${diff.inHours}h ago';
    if (diff.inDays == 1) return 'Yesterday';
    return '${diff.inDays} days ago';
  }
}

// ─── State ────────────────────────────────────────────────────────────────────

class BacklogState {
  final List<BacklogItem> items;

  const BacklogState({this.items = const []});

  BacklogState copyWith({List<BacklogItem>? items}) =>
      BacklogState(items: items ?? this.items);
}

// ─── Notifier ─────────────────────────────────────────────────────────────────

class BacklogNotifier extends StateNotifier<BacklogState> {
  BacklogNotifier()
    : super(
        BacklogState(
          items: [
            BacklogItem(
              id: '1',
              text: 'Design Review: Q4 Roadmap',
              addedAt: DateTime.now().subtract(const Duration(days: 2)),
            ),
            BacklogItem(
              id: '2',
              text: 'Weekly Synthesis Draft',
              addedAt: DateTime.now().subtract(const Duration(days: 1)),
            ),
            BacklogItem(
              id: '3',
              text: 'Market Analysis Briefing',
              addedAt: DateTime.now().subtract(const Duration(hours: 4)),
            ),
            BacklogItem(
              id: '4',
              text: 'Update Portfolio Case Studies',
              addedAt: DateTime.now().subtract(const Duration(days: 7)),
            ),
          ],
        ),
      );

  void addItem(String text) {
    if (text.trim().isEmpty) return;
    final item = BacklogItem(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      text: text.trim(),
      addedAt: DateTime.now(),
    );
    state = state.copyWith(items: [item, ...state.items]);
  }

  void editItem(String id, String newText) {
    if (newText.trim().isEmpty) return;
    state = state.copyWith(
      items: state.items
          .map((i) => i.id == id ? i.copyWith(text: newText.trim()) : i)
          .toList(),
    );
  }

  void deleteItem(String id) {
    state = state.copyWith(
      items: state.items.where((i) => i.id != id).toList(),
    );
  }
}

// ─── Provider ─────────────────────────────────────────────────────────────────

final backlogProvider = StateNotifierProvider<BacklogNotifier, BacklogState>(
  (ref) => BacklogNotifier(),
);
