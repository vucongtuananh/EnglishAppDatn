class SortQuestion {
  final String id;
  final String categoryId;
  final String title;
  final String description;
  final String type;
  final String level;

  SortQuestion({
    required this.id,
    required this.categoryId,
    required this.title,
    required this.description,
    required this.type,
    required this.level,
  });

  // Create an instance from JSON
  factory SortQuestion.fromJson(Map<String, dynamic> json) {
    return SortQuestion(
      id: json['id'].toString(),
      categoryId: json['category_id'].toString(),
      title: json['title'],
      description: json['description'],
      type: json['type'],
      level: json['level'].toString(),
    );
  }

  // Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'category_id': categoryId,
      'title': title,
      'description': description,
      'type': type,
      'level': level,
    };
  }

  // Create a copy of the object with updated properties
  SortQuestion copyWith({
    String? id,
    String? categoryId,
    String? title,
    String? description,
    String? type,
    String? level,
  }) {
    return SortQuestion(
      id: id ?? this.id,
      categoryId: categoryId ?? this.categoryId,
      title: title ?? this.title,
      description: description ?? this.description,
      type: type ?? this.type,
      level: level ?? this.level,
    );
  }

  @override
  String toString() {
    return 'SortQuestion{id: $id, categoryId: $categoryId, title: $title, description: $description, type: $type, level: $level}';
  }
}
