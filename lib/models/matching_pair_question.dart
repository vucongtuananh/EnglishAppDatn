class MatchingPairQuestion {
  final String typeOfQuestion;
  final List<Map<String, String>> items;

  MatchingPairQuestion({
    required this.typeOfQuestion,
    required this.items,
  });

  factory MatchingPairQuestion.fromJson(Map<String, dynamic> json) {
    return MatchingPairQuestion(
      typeOfQuestion: json['typeOfQuestion'] ?? '',
      items: (json['items'] as List<dynamic>? ?? []).map((item) => Map<String, String>.from(item)).toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'typeOfQuestion': typeOfQuestion,
      'items': items,
    };
  }
}
