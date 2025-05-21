import 'dart:convert';
import 'package:http/http.dart' as http;
import '../utils/constants.dart';
import 'data_client_service.dart';

class LessonService {
  // Các hàm khác nếu có...

  static Future<bool> markTopicCompleted({required int topicId, required int level}) async {
    String urlPath = "/api/v1/topic/completed";
    try {
      final response = await http.post(
        Uri.parse(API_URL + urlPath),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer ${DataClient.user.token!}",
        },
        body: jsonEncode({
          "topic_id": topicId,
          "level": level,
        }),
      );

      if (response.statusCode == 200) {
        // Có thể kiểm tra thêm response.body nếu cần
        return true;
      } else {
        print("Error: ${response.statusCode} - ${response.body}");
        return false;
      }
    } catch (e) {
      print("Exception in markTopicCompleted: $e");
      return false;
    }
  }
}
