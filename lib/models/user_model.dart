class UserModel {
  final int? id;
  final String? email;
  final String? urlAvatar;
  final String? role;
  final String? signInMethod;
  final String? completedLessons;
  final String? progress;
  final String? username;
  final int? streak;
  final String? language;
  final String? heart;
  final String? gem;
  final int? xp;
  final String? lastCompletionDate;
  final String? phone;
  final String? created_at;
  final LastLesson? lastLesson;
  final int? total_lessons;
  final double? total_score;

  UserModel({
    this.created_at,
    this.id,
    this.email,
    this.role,
    this.urlAvatar,
    this.signInMethod,
    this.completedLessons,
    this.progress,
    this.username,
    this.streak,
    this.language,
    this.heart,
    this.gem,
    this.xp,
    this.lastCompletionDate,
    this.phone,
    this.lastLesson,
    this.total_lessons,
    this.total_score,
  });

  // Convert UserModel object to a Map
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'urlAvatar': urlAvatar,
      'role': role,
      'completedLessons': completedLessons,
      'progress': progress,
      'user_name': username,
      'streak': streak,
      'language': language,
      'heart': heart,
      'gem': gem,
      'xp': xp,
      'lastCompletionDate': lastCompletionDate,
      'phone': phone,
      'created_at': created_at,
      'last_lesson': lastLesson?.toJson(),
      'total_lessons': total_lessons,
      'total_score': total_score,
    };
  }

  // Create a UserModel from Map
  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      created_at: json['created_at'] as String?,
      id: json['id'] as int?,
      email: json['email'] as String?,
      urlAvatar: json['urlAvatar'] as String?,
      role: json['role'] as String?,
      signInMethod: json['signInMethod'] as String?,
      completedLessons: json['completedLessons'] as String?,
      progress: json['progress'] as String?,
      username: json['user_name'] as String?,
      streak: json['streak'] ?? 0,
      language: json['language'] as String?,
      heart: json['heart'] as String?,
      gem: json['gem'] as String?,
      xp: json['xp'] as int?,
      lastCompletionDate: json['lastCompletionDate'] as String?,
      phone: json['phone'] as String?,
      lastLesson: json['last_lesson'] != null ? LastLesson.fromJson(json['last_lesson'] as Map<String, dynamic>) : null,
      total_lessons: json['total_lessons'] ?? 0,
      total_score: json['total_score'] ?? 0,
    );
  }
}

class LastLesson {
  int? lesson_id;
  double? score;
  double? percent;
  String? submitted_at;

  LastLesson({
    this.lesson_id,
    this.score,
    this.percent,
    this.submitted_at,
  });

  // Constructor từ JSON
  factory LastLesson.fromJson(Map<String, dynamic> json) {
    return LastLesson(
      lesson_id: json['lesson_id'] ?? 0,
      score: json['score'] ?? 0,
      percent: json['percent'] ?? 0,
      submitted_at: json['submitted_at'] ?? '',
    );
  }

  // Chuyển đổi thành JSON
  Map<String, dynamic> toJson() {
    return {
      'lesson_id': lesson_id,
      'score': score,
      'percent': percent,
      'submitted_at': submitted_at,
    };
  }
}
