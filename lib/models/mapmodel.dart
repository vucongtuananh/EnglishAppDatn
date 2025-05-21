import 'package:english_learning_app/models/lessonmodel.dart';

class MapModel {
  final int id;
  final String categoryName;
  final String? image;
  final String? color;
  final String? note;
  final String createdAt;
  final String updatedAt;
  final String? deletedAt;
  final List<LessonModel> lessons;

  MapModel({
    required this.id,
    required this.categoryName,
    this.image,
    this.color,
    this.note,
    required this.createdAt,
    required this.updatedAt,
    this.deletedAt,
    required this.lessons,
  });

  factory MapModel.fromJson(Map<String, dynamic> json) {
    return MapModel(
      id: json['id'],
      categoryName: json['category_name'],
      image: json['image'],
      color: json['color'],
      note: json['note'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
      deletedAt: json['deleted_at'],
      lessons: (json['topics'] as List<dynamic>).map((e) => LessonModel.fromJson(e)).toList(),
    );
  }
}
