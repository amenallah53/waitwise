import 'package:flutter_riverpod/flutter_riverpod.dart';

// ─── Model ────────────────────────────────────────────────────────────────────

class TaskItem {
  final String title;
  final bool done;
  final int remainingSeconds; // for timer
  const TaskItem({
    required this.title,
    required this.done,
    required this.remainingSeconds,
  });

  TaskItem copyWith({bool? done, int? remainingSeconds}) => TaskItem(
    title: title,
    done: done ?? this.done,
    remainingSeconds: remainingSeconds ?? this.remainingSeconds,
  );
}

// ─── State ────────────────────────────────────────────────────────────────────

class TasksState {
  final List<TaskItem> tasks;
  final int remainingSeconds;
  const TasksState({required this.tasks, required this.remainingSeconds});

  int get completedCount => tasks.where((t) => t.done).length;
  bool get allDone => completedCount == tasks.length;

  TasksState copyWith({List<TaskItem>? tasks, int? remainingSeconds}) =>
      TasksState(
        tasks: tasks ?? this.tasks,
        remainingSeconds: remainingSeconds ?? this.remainingSeconds,
      );
}

// ─── Notifier ─────────────────────────────────────────────────────────────────

class TasksNotifier extends StateNotifier<TasksState> {
  // Define a constant for the initial time
  static const int initialTime = 300;
  TasksNotifier()
    : super(
        const TasksState(
          remainingSeconds: initialTime,
          tasks: [
            TaskItem(
              title: 'Read 5 pages of your current book',
              done: false,
              remainingSeconds: initialTime,
            ),
            TaskItem(
              title: "Write down 3 things you're grateful for",
              done: false,
              remainingSeconds: initialTime,
            ),
            TaskItem(
              title: 'Review your goals for this week',
              done: false,
              remainingSeconds: initialTime,
            ),
            TaskItem(
              title: "Send that message you've been putting off",
              done: false,
              remainingSeconds: initialTime,
            ),
          ],
        ),
      );
  // Method to update the timer every second
  void decrementTimer() {
    if (state.remainingSeconds > 0) {
      state = state.copyWith(remainingSeconds: state.remainingSeconds - 1);
    }
  }

  void resetTimer() {
    state = state.copyWith(remainingSeconds: initialTime);
  }

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
