import 'dart:convert';
import 'package:http/http.dart' as http;
import 'dart:io';

// Class Topic cập nhật theo JSON thực tế
class Question {
  final int id;
  final String title;
  final int categoryId;
  final String description;
  final String level;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String? questionText;
  final String? correctAnswer;
  final Map<String, String>? options;
  final String? explain;
  final String type; // "sort", "multiple_choice", "text"
  final String? ipa;

  Question({
    required this.id,
    required this.title,
    required this.categoryId,
    required this.description,
    required this.level,
    required this.createdAt,
    required this.updatedAt,
    this.questionText,
    this.correctAnswer,
    this.options,
    this.explain,
    required this.type,
    this.ipa,
  });

  factory Question.fromJson(Map<String, dynamic> json) {
    // Parse options nếu có
    Map<String, String>? parsedOptions;
    if (json['options'] != null && json['options'] is String) {
      try {
        final Map<String, dynamic> optionsMap = jsonDecode(json['options']);
        parsedOptions = optionsMap.map((key, value) => MapEntry(key, value.toString()));
      } catch (e) {
        parsedOptions = null;
      }
    }

    return Question(
      id: json['id'],
      title: json['title'],
      categoryId: json['category_id'],
      description: json['description'],
      level: json['level'],
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
      questionText: json['question_text'],
      correctAnswer: json['correct_answer'],
      options: parsedOptions,
      explain: json['explain'],
      type: json['type'] ?? '',
      ipa: json['ipa'],
    );
  }
}