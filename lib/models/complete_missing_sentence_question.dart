import 'package:english_learning_app/utils/constants.dart';

class CompleteMissingSentenceQuestion {
  final String typeOfQuestion;
  final String expectedSentence;
  final String missingSentence;
  final String correctanswers;

  CompleteMissingSentenceQuestion({
    this.typeOfQuestion = completeMissingSentenceQuestion,
    required this.expectedSentence,
    required this.missingSentence,
    required this.correctanswers,
  });

  factory CompleteMissingSentenceQuestion.fromJson(Map<String, dynamic> json) {
    return CompleteMissingSentenceQuestion(
      typeOfQuestion: json['typeOfQuestion'] ?? completeMissingSentenceQuestion,
      expectedSentence: json['expectedSentence'] ?? '',
      missingSentence: json['missingSentence'] ?? '',
      correctanswers: json['correctanswers'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'typeOfQuestion': typeOfQuestion,
      'expectedSentence': expectedSentence,
      'missingSentence': missingSentence,
      'correctanswers': correctanswers,
    };
  }
}
