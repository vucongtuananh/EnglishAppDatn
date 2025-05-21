// import 'package:english_learning_app/models/topicmodel.dart';

// class SectionModel {
//   final String id;
//   final String description;
//   final List<TopicModel> topics;

//   SectionModel({
//     required this.id,
//     required this.description,
//     required this.topics,
//   });

//   factory SectionModel.fromJson(Map<String, dynamic> json) {
//     return SectionModel(
//       id: json['id'] ?? '',
//       description: json['description'] ?? '',
//       topics: (json['topics'] as List<dynamic>? ?? []).map((e) => TopicModel.fromJson(e)).toList(),
//     );
//   }

//   Map<String, dynamic> toJson() {
//     return {
//       'id': id,
//       'description': description,
//       'topics': topics.map((e) => e.toJson()).toList(),
//     };
//   }
// }
