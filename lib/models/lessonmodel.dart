class LessonModel {
  final int id;
  final int categoryId;
  final String name;
  final String? image;
  final int level;
  final int isExam;
  final String createdAt;
  final String updatedAt;
  final ProgressModel progress;

  LessonModel({
    required this.id,
    required this.categoryId,
    required this.name,
    this.image,
    required this.level,
    required this.isExam,
    required this.createdAt,
    required this.updatedAt,
    required this.progress,
  });

  factory LessonModel.fromJson(Map<String, dynamic> json) {
    return LessonModel(
      id: json['id'],
      categoryId: json['category_id'],
      name: json['name'],
      image: json['image'],
      level: json['level'],
      isExam: json['is_exam'] ?? 0,
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
      progress: ProgressModel.fromJson(json['progress']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'category_id': categoryId,
      'name': name,
      'image': image,
      'level': level,
      'is_exam': isExam,
      'created_at': createdAt,
      'updated_at': updatedAt,
      'progress': progress.toJson(),
    };
  }
}

class ProgressModel {
  final int currentLevel;
  final bool isCompleted;
  final bool isOpen;

  ProgressModel({
    required this.currentLevel,
    required this.isCompleted,
    required this.isOpen,
  });

  factory ProgressModel.fromJson(Map<String, dynamic> json) {
    return ProgressModel(
      currentLevel: json['current_level'],
      isCompleted: json['is_completed'],
      isOpen: json['is_open'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'current_level': currentLevel,
      'is_completed': isCompleted,
      'is_open': isOpen,
    };
  }
}

