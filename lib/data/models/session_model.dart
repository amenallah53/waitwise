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
    final type = json['session_type'] as String;

    final rawAi = json['ai_content'];
    final rawUser = json['user_response'];

    // Handle ai_content safely
    Map<String, dynamic> aiContent;
    if (rawAi is String) {
      aiContent = jsonDecode(rawAi);
    } else if (rawAi is Map<String, dynamic>) {
      aiContent = rawAi;
    } else {
      throw Exception('Invalid ai_content format');
    }

    // Handle nullable user_response safely
    Map<String, dynamic>? userResponse;
    if (rawUser == null) {
      userResponse = null;
    } else if (rawUser is String) {
      userResponse = jsonDecode(rawUser);
    } else if (rawUser is Map<String, dynamic>) {
      userResponse = rawUser;
    } else {
      throw Exception('Invalid user_response format');
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

  factory _CommonFields.fromJson(Map<String, dynamic> json) => _CommonFields(
    id: json['id'] as String?,
    userId: json['user_id'] as String,
    title: json['title'] as String?,
    context: json['context'] as String?,
    durationMinutes: json['duration_minutes'] as int,
    userMood: json['user_mood'] as String?,
    completed: json['completed'] as bool? ?? false,
    createdAt: DateTime.parse(json['created_at'] as String),
  );
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
      ReflectionContent(prompt: json['prompt'] as String);

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
    id: json['id'] as int,
    text: json['text'] as String,
    isComplete: json['is_complete'] as bool? ?? false,
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
    prompt: json['prompt'] as String,
    steps: (json['steps'] as List)
        .map((s) => TaskStep.fromJson(s as Map<String, dynamic>))
        .toList(),
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
    question: json['question'] as String,
    options: List<String>.from(json['options'] as List),
    correctIndex: json['correct_index'] as int,
    explanation: json['explanation'] as String,
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
    questions: (json['questions'] as List)
        .map((q) => QuizQuestion.fromJson(q as Map<String, dynamic>))
        .toList(),
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
