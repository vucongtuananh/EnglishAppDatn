class PronunciationQuestion {
  final String id;
  final String categoryId;
  final String title;
  final String description;
  final String type;
  final String level;
  final String ipa;

  PronunciationQuestion({
    required this.id,
    required this.categoryId,
    required this.title,
    required this.description,
    required this.type,
    required this.level,
    required this.ipa,
  });

  // Create an instance from JSON
  factory PronunciationQuestion.fromJson(Map<String, dynamic> json) {
    return PronunciationQuestion(
      id: json['id'].toString(),
      categoryId: json['category_id'].toString(),
      title: json['title'],
      description: json['description'],
      type: json['type'],
      level: json['level'].toString(),
      ipa: json['ipa'],
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
      'ipa': ipa,
    };
  }

  // Create a copy of the object with updated properties
  PronunciationQuestion copyWith({
    String? id,
    String? categoryId,
    String? title,
    String? description,
    String? type,
    String? level,
    String? ipa,
  }) {
    return PronunciationQuestion(
      id: id ?? this.id,
      categoryId: categoryId ?? this.categoryId,
      title: title ?? this.title,
      description: description ?? this.description,
      type: type ?? this.type,
      level: level ?? this.level,
      ipa: ipa ?? this.ipa,
    );
  }

  // Split IPA into words for easier display or processing
  List<String> get ipaWords {
    // This splits the IPA string by spaces
    return ipa.split(' ');
  }

  // Split title into words to match with IPA
  List<String> get titleWords {
    return title.split(' ');
  }

  // Create a map of words with their IPA pronunciation
  Map<String, String> get wordToPronunciation {
    final Map<String, String> result = {};
    final List<String> words = titleWords;
    final List<String> pronunciations = ipaWords;

    // Match each word with its pronunciation as much as possible
    final int minLength = words.length < pronunciations.length ? words.length : pronunciations.length;

    for (int i = 0; i < minLength; i++) {
      result[words[i]] = pronunciations[i];
    }

    return result;
  }

  @override
  String toString() {
    return 'PronunciationQuestion{id: $id, categoryId: $categoryId, '
        'title: $title, type: $type, level: $level, ipa: $ipa}';
  }
}
