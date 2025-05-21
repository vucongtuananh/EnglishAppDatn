import 'package:english_learning_app/utils/constants.dart';

class CompleteConversationQuestion {
  final String typeOfQuestion;
  final Map<String, String> question;
  final Map<String, String> correctAnswer;
  final List<String> items;

  CompleteConversationQuestion({
    this.typeOfQuestion = completeConversationQuestion,
    required this.question,
    required this.correctAnswer,
    required this.items,
  });

  factory CompleteConversationQuestion.fromJson(Map<String, dynamic> json) {
    return CompleteConversationQuestion(
      typeOfQuestion: json['typeOfQuestion'] ?? completeConversationQuestion,
      question: Map<String, String>.from(json['question'] ?? {}),
      correctAnswer: Map<String, String>.from(json['correctAnswer'] ?? {}),
      items: List<String>.from(json['items'] ?? []),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'typeOfQuestion': typeOfQuestion,
      'question': question,
      'correctAnswer': correctAnswer,
      'items': items,
    };
  }
}
