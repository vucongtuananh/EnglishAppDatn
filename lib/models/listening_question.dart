import 'package:english_learning_app/utils/constants.dart';

class ListeningQuestion {
  final String typeOfQuestion;
  final String correctAnswer;
  final List<String> items;

  ListeningQuestion({
    this.typeOfQuestion = listenQuestion,
    required this.correctAnswer,
    required this.items,
  });

  factory ListeningQuestion.fromJson(Map<String, dynamic> json) {
    return ListeningQuestion(
      typeOfQuestion: json['typeOfQuestion'] ?? listenQuestion,
      correctAnswer: json['correctAnswer'] ?? '',
      items: List<String>.from(json['items'] ?? []),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'typeOfQuestion': typeOfQuestion,
      'correctAnswer': correctAnswer,
      'items': items,
    };
  }
}
