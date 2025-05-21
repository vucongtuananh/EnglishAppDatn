class TranslationQuestion {
  final String typeOfQuestion;
  final String question;
  final String mean;
  final List<String> answers;

  TranslationQuestion({
    required this.typeOfQuestion,
    required this.question,
    required this.mean,
    required this.answers,
  });

  factory TranslationQuestion.fromJson(Map<String, dynamic> json) {
    return TranslationQuestion(
      typeOfQuestion: json['typeOfQuestion'] ?? '',
      question: json['question'] ?? '',
      mean: json['mean'] ?? '',
      answers: List<String>.from(json['answers'] ?? []),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'typeOfQuestion': typeOfQuestion,
      'question': question,
      'mean': mean,
      'answers': answers,
    };
  }
}
