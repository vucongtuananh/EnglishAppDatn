import 'dart:convert';

import 'package:http/http.dart' as http;

import '../models/topicmodel.dart';
import '../utils/constants.dart';
import 'data_client_service.dart';

class TopicListService {
  static Future<List<TopicModel>> getListTopic() async {
    String urlPath = "/api/v1/categories/get-all";

    try {
      final response = await http.get(
        Uri.parse(API_URL + urlPath),
        headers: {"Content-Type": "application/json", "Authorization": "Bearer ${DataClient.user.token!}"},
      );
      await Future.delayed(Duration(seconds: 2));

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = jsonDecode(response.body);

        if (responseData['status'] == 'success' && responseData['data'] != null) {
          final List<dynamic> topicsData = responseData['data'];
          return topicsData.map((json) => TopicModel.fromJson(json)).toList();
        } else {
          print("Error: Invalid response format - ${response.body}");
          return [];
        }
      } else {
        print("Error: ${response.statusCode} - ${response.body}");
        return [];
      }
    } catch (e) {
      print("Exception in getListTopic: $e");
      return [];
    }
  }
}
