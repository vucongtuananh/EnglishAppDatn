class MultiChoiceQuestion {
  final String id;
  final String categoryId;
  final String title;
  final String description;
  final String type;
  final String questionText;
  final String correctAnswer;
  final Map<String, String> options;
  final String explain;
  final String level;

  MultiChoiceQuestion({
    required this.id,
    required this.categoryId,
    required this.title,
    required this.description,
    required this.type,
    required this.questionText,
    required this.correctAnswer,
    required this.options,
    required this.explain,
    required this.level,
  });

  // Create an instance from JSON
  factory MultiChoiceQuestion.fromJson(Map<String, dynamic> json) {
    // Convert options from dynamic to Map<String, String>
    Map<String, String> optionsMap = {};
    if (json['options'] != null) {
      json['options'].forEach((key, value) {
        optionsMap[key.toString()] = value.toString();
      });
    }

    return MultiChoiceQuestion(
      id: json['id'].toString(),
      categoryId: json['category_id'].toString(),
      title: json['title'],
      description: json['description'],
      type: json['type'],
      questionText: json['question_text'],
      correctAnswer: json['correct_answer'],
      options: optionsMap,
      explain: json['explain'],
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
      'question_text': questionText,
      'correct_answer': correctAnswer,
      'options': options,
      'explain': explain,
      'level': level,
    };
  }

  // Create a copy of the object with updated properties
  MultiChoiceQuestion copyWith({
    String? id,
    String? categoryId,
    String? title,
    String? description,
    String? type,
    String? questionText,
    String? correctAnswer,
    Map<String, String>? options,
    String? explain,
    String? level,
  }) {
    return MultiChoiceQuestion(
      id: id ?? this.id,
      categoryId: categoryId ?? this.categoryId,
      title: title ?? this.title,
      description: description ?? this.description,
      type: type ?? this.type,
      questionText: questionText ?? this.questionText,
      correctAnswer: correctAnswer ?? this.correctAnswer,
      options: options ?? this.options,
      explain: explain ?? this.explain,
      level: level ?? this.level,
    );
  }

  // Check if an answer is correct
  bool isCorrectAnswer(String answer) {
    return answer.toLowerCase() == correctAnswer.toLowerCase();
  }

  // Get correct option text
  String get correctOptionText {
    return options[correctAnswer] ?? '';
  }

  @override
  String toString() {
    return 'MultiChoiceQuestion{id: $id, categoryId: $categoryId, title: $title, '
        'questionText: $questionText, correctAnswer: $correctAnswer, '
        'options: $options, level: $level}';
  }
}
