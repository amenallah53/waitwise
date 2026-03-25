import 'package:flutter_riverpod/flutter_riverpod.dart';

// ─── Model ────────────────────────────────────────────────────────────────────

class TaskItem {
  final String title;
  final bool done;

  const TaskItem({required this.title, required this.done});

  TaskItem copyWith({bool? done}) =>
      TaskItem(title: title, done: done ?? this.done);
}

// ─── State ────────────────────────────────────────────────────────────────────

class TasksState {
  final List<TaskItem> tasks;

  const TasksState({required this.tasks});

  int get completedCount => tasks.where((t) => t.done).length;
  bool get allDone => completedCount == tasks.length;

  TasksState copyWith({List<TaskItem>? tasks}) =>
      TasksState(tasks: tasks ?? this.tasks);
}

// ─── Notifier ─────────────────────────────────────────────────────────────────

class TasksNotifier extends StateNotifier<TasksState> {
  TasksNotifier()
    : super(
        const TasksState(
          tasks: [
            TaskItem(title: 'Read 5 pages of your current book', done: false),
            TaskItem(
              title: "Write down 3 things you're grateful for",
              done: false,
            ),
            TaskItem(title: 'Review your goals for this week', done: false),
            TaskItem(
              title: "Send that message you've been putting off",
              done: false,
            ),
          ],
        ),
      );

  void toggleTask(int index) {
    final updated = [...state.tasks];
    updated[index] = updated[index].copyWith(done: !updated[index].done);
    state = state.copyWith(tasks: updated);
  }
}

// ─── Provider ─────────────────────────────────────────────────────────────────

final tasksProvider = StateNotifierProvider<TasksNotifier, TasksState>(
  (ref) => TasksNotifier(),
);
