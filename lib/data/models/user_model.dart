// ============================================================
// lib/data/models/user_model.dart
// ============================================================

class UserModel {
  final String? id;
  final String name;
  final List<String> interests;
  final DateTime createdAt;

  final int sessionsCompleted;
  final int currentStreak;
  final int bestStreak;
  final int timesReclaimed;

  final List<UserBacklog> backlogs;

  const UserModel({
    this.id,
    required this.name,
    required this.interests,
    required this.createdAt,
    this.sessionsCompleted = 0,
    this.currentStreak = 0,
    this.bestStreak = 0,
    this.timesReclaimed = 0,
    this.backlogs = const [],
  });

  // ─────────────────────────────────────────
  // FROM JSON
  // ─────────────────────────────────────────

  factory UserModel.fromJson(
    Map<String, dynamic> json, {
    List<Map<String, dynamic>>? backlogRows,
  }) {
    return UserModel(
      id: json['id'] as String?,
      name: json['name'] as String,
      interests: List<String>.from(json['interests'] ?? []),
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'] as String)
          : DateTime.now(),
      sessionsCompleted: json['sessions_completed'] ?? 0,
      currentStreak: json['current_streak'] ?? 0,
      bestStreak: json['best_streak'] ?? 0,
      timesReclaimed: json['times_reclaimed'] ?? 0,
      backlogs: backlogRows != null
          ? backlogRows.map((b) => UserBacklog.fromJson(b)).toList()
          : [],
    );
  }

  // ─────────────────────────────────────────
  // TO JSON
  // ─────────────────────────────────────────

  Map<String, dynamic> toJson() => {
    if (id != null) 'id': id,
    'name': name,
    'interests': interests,
    'created_at': createdAt.toIso8601String(),
    'sessions_completed': sessionsCompleted,
    'current_streak': currentStreak,
    'best_streak': bestStreak,
    'times_reclaimed': timesReclaimed,
  };

  UserModel copyWith({
    String? name,
    List<String>? interests,
    int? sessionsCompleted,
    int? currentStreak,
    int? bestStreak,
    int? timesReclaimed,
    List<UserBacklog>? backlogs,
  }) {
    return UserModel(
      id: id,
      name: name ?? this.name,
      interests: interests ?? this.interests,
      createdAt: createdAt,
      sessionsCompleted: sessionsCompleted ?? this.sessionsCompleted,
      currentStreak: currentStreak ?? this.currentStreak,
      bestStreak: bestStreak ?? this.bestStreak,
      timesReclaimed: timesReclaimed ?? this.timesReclaimed,
      backlogs: backlogs ?? this.backlogs,
    );
  }
}

// ============================================================
// USER BACKLOG
// ============================================================

class UserBacklog {
  final String? id;
  final String userId;
  final String content;
  final DateTime date;

  const UserBacklog({
    this.id,
    required this.userId,
    required this.content,
    required this.date,
  });

  factory UserBacklog.fromJson(Map<String, dynamic> json) {
    return UserBacklog(
      id: json['id'] as String?,
      userId: json['user_id'] as String,
      content: json['content'] as String,
      date: DateTime.parse(json['date'] as String),
    );
  }

  Map<String, dynamic> toJson() => {
    if (id != null) 'id': id,
    'user_id': userId,
    'content': content,
    'date': date.toIso8601String(),
  };

  UserBacklog copyWith({String? content, DateTime? date}) {
    return UserBacklog(
      id: id,
      userId: userId,
      content: content ?? this.content,
      date: date ?? this.date,
    );
  }
}
