import 'package:english_learning_app/models/pronunciation_mistake.dart';
import 'package:english_learning_app/viewmodels/question_viewmodel.dart';

class PronunciationResult {
  final double mistakePercentage;
  final List<PronunciationMistake> mistakes;
  final String text;

  PronunciationResult({
    required this.mistakePercentage,
    required this.mistakes,
    required this.text,
  });

  factory PronunciationResult.fromJson(Map<String, dynamic> json) {
    return PronunciationResult(
      mistakePercentage: json['mistake_percentage'].toDouble(),
      mistakes: (json['mistakes'] as List).map((mistake) => PronunciationMistake.fromJson(mistake)).toList(),
      text: json['text'],
    );
  }
}