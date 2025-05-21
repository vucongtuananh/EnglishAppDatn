import 'package:english_learning_app/utils/constants.dart';

class AnswersCardQuestion {
  final String typeOfQuestion;
  final String question;
  final String correctAnswer;
  final List<String> answers;

  AnswersCardQuestion({
    this.typeOfQuestion = cardMutilChoiceQuestion,
    required this.question,
    required this.correctAnswer,
    required this.answers,
  });

  factory AnswersCardQuestion.fromJson(Map<String, dynamic> json) {
    return AnswersCardQuestion(
      typeOfQuestion: json['typeOfQuestion'] ?? cardMutilChoiceQuestion,
      question: json['question'] ?? '',
      correctAnswer: json['correctAnswer'] ?? '',
      answers: List<String>.from(json['answers'] ?? []),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'typeOfQuestion': typeOfQuestion,
      'question': question,
      'correctAnswer': correctAnswer,
      'answers': answers,
    };
  }
}
