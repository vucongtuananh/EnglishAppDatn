import 'package:english_learning_app/utils/constants.dart';

class ImageSelectionQuestion {
  final String typeOfQuestion;
  final String expectedWord;
  final String correctAnswer;
  final List<Map<String, String>> items;

  ImageSelectionQuestion({
    this.typeOfQuestion = imageSelectionQuestions,
    required this.expectedWord,
    required this.correctAnswer,
    required this.items,
  });

  factory ImageSelectionQuestion.fromJson(Map<String, dynamic> json) {
    return ImageSelectionQuestion(
      typeOfQuestion: json['typeOfQuestion'] ?? imageSelectionQuestions,
      expectedWord: json['expectedWord'] ?? '',
      correctAnswer: json['correctAnswer'] ?? '',
      items: (json['items'] as List<dynamic>? ?? []).map((item) => Map<String, String>.from(item)).toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'typeOfQuestion': typeOfQuestion,
      'expectedWord': expectedWord,
      'correctAnswer': correctAnswer,
      'items': items,
    };
  }
}
