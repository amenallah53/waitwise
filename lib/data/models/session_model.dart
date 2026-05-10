// ============================================================
// lib/data/models/session_model.dart
// ============================================================
// Parent class + 3 typed subclasses for each session type.
// Each subclass owns its ai_content and user_response shape.
// ============================================================

// ─────────────────────────────────────────
// SHARED ENUMS
// ─────────────────────────────────────────

import 'dart:convert';
import 'package:uuid/uuid.dart';

enum SessionType { reflection, task, quiz }

// ─────────────────────────────────────────
// PARENT CLASS
// ─────────────────────────────────────────

abstract class SessionModel {
  final String? id;
  final String userId;
  final String? title;
  final String? context;
  final int durationMinutes;
  final String? userMood;
  final SessionType sessionType;
  final bool completed;
  final DateTime createdAt;

  const SessionModel({
    this.id,
    required this.userId,
    this.title,
    required this.context,
    required this.durationMinutes,
    this.userMood,
    required this.sessionType,
    this.completed = false,
    required this.createdAt,
  });

  // Factory: reads the DB row and returns the correct subclass
  /*factory SessionModel.fromJson(Map<String, dynamic> json) {
    final type = json['session_type'] as String;
    final aiContent = json['ai_content'] as Map<String, dynamic>;
    final userResponse = json['user_response'] as Map<String, dynamic>?;
    final common = _CommonFields.fromJson(json);

    switch (type) {
      case 'reflection':
        return ReflectionSession(
          id: common.id,
          userId: common.userId,
          title: common.title,
          context: common.context,
          durationMinutes: common.durationMinutes,
          userMood: common.userMood,
          completed: common.completed,
          createdAt: common.createdAt,
          aiContent: ReflectionContent.fromJson(aiContent),
          userResponse: userResponse != null
              ? ReflectionResponse.fromJson(userResponse)
              : null,
        );
      case 'task':
        return TaskSession(
          id: common.id,
          userId: common.userId,
          title: common.title,
          context: common.context,
          durationMinutes: common.durationMinutes,
          userMood: common.userMood,
          completed: common.completed,
          createdAt: common.createdAt,
          aiContent: TaskContent.fromJson(aiContent),
          userResponse: userResponse != null
              ? TaskResponse.fromJson(userResponse)
              : null,
        );
      case 'quiz':
        return QuizSession(
          id: common.id,
          userId: common.userId,
          title: common.title,
          context: common.context,
          durationMinutes: common.durationMinutes,
          userMood: common.userMood,
          completed: common.completed,
          createdAt: common.createdAt,
          aiContent: QuizContent.fromJson(aiContent),
          userResponse: userResponse != null
              ? QuizResponse.fromJson(userResponse)
              : null,
        );
      default:
        throw Exception('Unknown session type: $type');
    }
  }*/

  factory SessionModel.fromJson(Map<String, dynamic> json) {
    final type = json['session_type']?.toString() ?? 'task'; // fallback to task

    final rawAi = json['ai_content'];
    final rawUser = json['user_response'];

    // Handle ai_content safely
    Map<String, dynamic> aiContent;
    if (rawAi is String) {
      aiContent = jsonDecode(rawAi);
    } else if (rawAi is Map) {
      aiContent = Map<String, dynamic>.from(rawAi);
    } else {
      aiContent = {'prompt': 'Focus session'}; // Fallback
    }

    // Handle nullable user_response safely
    Map<String, dynamic>? userResponse;
    if (rawUser == null) {
      userResponse = null;
    } else if (rawUser is String) {
      userResponse = jsonDecode(rawUser);
    } else if (rawUser is Map) {
      userResponse = Map<String, dynamic>.from(rawUser);
    } else {
      userResponse = null; // Fallback
    }

    final common = _CommonFields.fromJson(json);

    switch (type) {
      case 'reflection':
        return ReflectionSession(
          id: common.id,
          userId: common.userId,
          title: common.title,
          context: common.context,
          durationMinutes: common.durationMinutes,
          userMood: common.userMood,
          completed: common.completed,
          createdAt: common.createdAt,
          aiContent: ReflectionContent.fromJson(aiContent),
          userResponse: userResponse != null
              ? ReflectionResponse.fromJson(userResponse)
              : null,
        );

      case 'task':
        return TaskSession(
          id: common.id,
          userId: common.userId,
          title: common.title,
          context: common.context,
          durationMinutes: common.durationMinutes,
          userMood: common.userMood,
          completed: common.completed,
          createdAt: common.createdAt,
          aiContent: TaskContent.fromJson(aiContent),
          userResponse: userResponse != null
              ? TaskResponse.fromJson(userResponse)
              : null,
        );

      case 'quiz':
        return QuizSession(
          id: common.id,
          userId: common.userId,
          title: common.title,
          context: common.context,
          durationMinutes: common.durationMinutes,
          userMood: common.userMood,
          completed: common.completed,
          createdAt: common.createdAt,
          aiContent: QuizContent.fromJson(aiContent),
          userResponse: userResponse != null
              ? QuizResponse.fromJson(userResponse)
              : null,
        );

      default:
        throw Exception('Unknown session type: $type');
    }
  }

  // Each subclass implements its own toJson
  Map<String, dynamic> toJson();

  // Common DB fields shared across all subclasses
  Map<String, dynamic> _baseToJson() => {
    if (id != null) 'id': id,
    'user_id': userId,
    'title': title,
    'context': context,
    'duration_minutes': durationMinutes,
    'user_mood': userMood,
    'session_type': sessionType.name,
    'completed': completed,
  };
}

// Internal helper to avoid repeating fromJson logic for common fields
class _CommonFields {
  final String? id;
  final String userId;
  final String? title;
  final String? context;
  final int durationMinutes;
  final String? userMood;
  final bool completed;
  final DateTime createdAt;

  _CommonFields({
    required this.id,
    required this.userId,
    required this.title,
    required this.context,
    required this.durationMinutes,
    required this.userMood,
    required this.completed,
    required this.createdAt,
  });

  factory _CommonFields.fromJson(Map<String, dynamic> json) {
    String? finalId = json['id']?.toString();
    if (finalId == null || finalId == 'undefined' || finalId.isEmpty) {
      finalId = json['session_id']?.toString();
    }
    if (finalId == null || finalId == 'undefined' || finalId.isEmpty) {
      finalId = const Uuid().v4();
    }

    return _CommonFields(
      id: finalId,
      userId: json['user_id']?.toString() ?? 'unknown',
      title: json['title']?.toString(),
      context: json['context']?.toString(),
      durationMinutes: json['duration_minutes'] != null 
          ? int.tryParse(json['duration_minutes'].toString()) ?? 5 
          : 5,
      userMood: json['user_mood']?.toString(),
      completed: json['completed'] == true || json['completed'] == 'true',
      createdAt: json['created_at'] != null 
          ? DateTime.tryParse(json['created_at'].toString()) ?? DateTime.now() 
          : DateTime.now(),
    );
  }
}

// ─────────────────────────────────────────
// REFLECTION
// ─────────────────────────────────────────

class ReflectionSession extends SessionModel {
  final ReflectionContent aiContent;
  final ReflectionResponse? userResponse;

  const ReflectionSession({
    super.id,
    required super.userId,
    super.title,
    required super.context,
    required super.durationMinutes,
    super.userMood,
    super.completed,
    required super.createdAt,
    required this.aiContent,
    this.userResponse,
  }) : super(sessionType: SessionType.reflection);

  @override
  Map<String, dynamic> toJson() => {
    ..._baseToJson(),
    'ai_content': aiContent.toJson(),
    'user_response': userResponse?.toJson(),
  };
}

/// What the AI generates for a reflection session
class ReflectionContent {
  final String prompt;

  const ReflectionContent({required this.prompt});

  factory ReflectionContent.fromJson(Map<String, dynamic> json) =>
      ReflectionContent(prompt: json['prompt']?.toString() ?? 'Take a moment to reflect.');

  Map<String, dynamic> toJson() => {'type': 'reflection', 'prompt': prompt};
}

/// What the user submits after a reflection session
class ReflectionResponse {
  final String text;

  const ReflectionResponse({required this.text});

  factory ReflectionResponse.fromJson(Map<String, dynamic> json) =>
      ReflectionResponse(text: json['text'] as String);

  Map<String, dynamic> toJson() => {'text': text};
}

// ─────────────────────────────────────────
// TASK
// ─────────────────────────────────────────

class TaskSession extends SessionModel {
  final TaskContent aiContent;
  final TaskResponse? userResponse;

  const TaskSession({
    super.id,
    required super.userId,
    super.title,
    required super.context,
    required super.durationMinutes,
    super.userMood,
    super.completed,
    required super.createdAt,
    required this.aiContent,
    this.userResponse,
  }) : super(sessionType: SessionType.task);

  @override
  Map<String, dynamic> toJson() => {
    ..._baseToJson(),
    'ai_content': aiContent.toJson(),
    'user_response': userResponse?.toJson(),
  };
}

/// A single step inside a task session
class TaskStep {
  final int id;
  final String text;
  final bool isComplete;

  const TaskStep({
    required this.id,
    required this.text,
    this.isComplete = false,
  });

  factory TaskStep.fromJson(Map<String, dynamic> json) => TaskStep(
    id: json['id'] != null ? int.tryParse(json['id'].toString()) ?? 0 : 0,
    text: json['text']?.toString() ?? 'Task step',
    isComplete: json['is_complete'] == true || json['is_complete'] == 'true',
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'text': text,
    'is_complete': isComplete,
  };

  // Returns a copy with isComplete toggled
  TaskStep copyWith({bool? isComplete}) =>
      TaskStep(id: id, text: text, isComplete: isComplete ?? this.isComplete);
}

/// What the AI generates for a task session
class TaskContent {
  final String prompt;
  final List<TaskStep> steps;

  const TaskContent({required this.prompt, required this.steps});

  factory TaskContent.fromJson(Map<String, dynamic> json) => TaskContent(
    prompt: json['prompt']?.toString() ?? 'Here are some quick tasks:',
    steps: json['steps'] != null 
        ? (json['steps'] as List)
            .map((s) => TaskStep.fromJson(Map<String, dynamic>.from(s as Map)))
            .toList()
        : [],
  );

  Map<String, dynamic> toJson() => {
    'type': 'task',
    'prompt': prompt,
    'steps': steps.map((s) => s.toJson()).toList(),
  };
}

/// What the user submits — steps with their completion state
class TaskResponse {
  final List<TaskStep> steps;
  final bool fullyCompleted;

  const TaskResponse({required this.steps, required this.fullyCompleted});

  factory TaskResponse.fromJson(Map<String, dynamic> json) => TaskResponse(
    steps: (json['steps'] as List)
        .map((s) => TaskStep.fromJson(s as Map<String, dynamic>))
        .toList(),
    fullyCompleted: json['fully_completed'] as bool? ?? false,
  );

  Map<String, dynamic> toJson() => {
    'steps': steps.map((s) => s.toJson()).toList(),
    'fully_completed': fullyCompleted,
  };
}

// ─────────────────────────────────────────
// QUIZ
// ─────────────────────────────────────────

class QuizSession extends SessionModel {
  final QuizContent aiContent;
  final QuizResponse? userResponse;

  const QuizSession({
    super.id,
    required super.userId,
    super.title,
    required super.context,
    required super.durationMinutes,
    super.userMood,
    super.completed,
    required super.createdAt,
    required this.aiContent,
    this.userResponse,
  }) : super(sessionType: SessionType.quiz);

  @override
  Map<String, dynamic> toJson() => {
    ..._baseToJson(),
    'ai_content': aiContent.toJson(),
    'user_response': userResponse?.toJson(),
  };
}

/// A single question inside a quiz session
class QuizQuestion {
  final String question;
  final List<String> options;
  final int correctIndex;
  final String explanation;

  const QuizQuestion({
    required this.question,
    required this.options,
    required this.correctIndex,
    required this.explanation,
  });

  factory QuizQuestion.fromJson(Map<String, dynamic> json) => QuizQuestion(
    question: json['question']?.toString() ?? 'Question?',
    options: json['options'] != null 
        ? List<String>.from((json['options'] as List).map((e) => e.toString())) 
        : ['Option A', 'Option B'],
    correctIndex: json['correct_index'] != null ? int.tryParse(json['correct_index'].toString()) ?? 0 : 0,
    explanation: json['explanation']?.toString() ?? '',
  );

  Map<String, dynamic> toJson() => {
    'question': question,
    'options': options,
    'correct_index': correctIndex,
    'explanation': explanation,
  };
}

/// What the AI generates for a quiz session
class QuizContent {
  final List<QuizQuestion> questions;

  const QuizContent({required this.questions});

  factory QuizContent.fromJson(Map<String, dynamic> json) => QuizContent(
    questions: json['questions'] != null 
        ? (json['questions'] as List)
            .map((q) => QuizQuestion.fromJson(Map<String, dynamic>.from(q as Map)))
            .toList()
        : [],
  );

  Map<String, dynamic> toJson() => {
    'type': 'quiz',
    'questions': questions.map((q) => q.toJson()).toList(),
  };
}

/// What the user submits — their selected answer per question + score
class QuizResponse {
  final List<int> answers; // selected index per question
  final int score;
  final int total;

  const QuizResponse({
    required this.answers,
    required this.score,
    required this.total,
  });

  factory QuizResponse.fromJson(Map<String, dynamic> json) => QuizResponse(
    answers: List<int>.from(json['answers'] as List),
    score: json['score'] as int,
    total: json['total'] as int,
  );

  Map<String, dynamic> toJson() => {
    'answers': answers,
    'score': score,
    'total': total,
  };
}
