import 'dart:convert';

import 'package:english_learning_app/models/question_model.dart';
import 'package:english_learning_app/service/data_client_service.dart';
import 'package:english_learning_app/utils/constants.dart';
import 'package:http/http.dart' as http;

class QuestionService {
  Future<List<Question>> getQuestionsByLevel(int level) async {
    try {
      final response = await http.get(
        Uri.parse('$API_URL/api/v1/topic/$level'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          "Authorization": "Bearer ${DataClient.user.token!}",
        },
      );

      final Map<String, dynamic> responseData = jsonDecode(response.body);

      if (response.statusCode == 200) {
        final List<dynamic> topicsData = responseData['data'];
        return topicsData.map<Question>((topicJson) => Question.fromJson(topicJson)).toList();
      } else {
        print("Lỗi lấy câu hỏi: ${responseData['message'] ?? 'Không có thông báo lỗi'}");
        return [];
      }
    } catch (e) {
      print("Lỗi ngoại lệ khi lấy câu hỏi: $e");
      return [];
    }
  }
}
