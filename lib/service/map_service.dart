import 'dart:convert';

import 'package:english_learning_app/models/mapmodel.dart';
import 'package:http/http.dart' as http;

import '../utils/constants.dart';
import 'data_client_service.dart';

class MapService {
  static Future<MapModel> getListMap({required int? categoryId, int currentPage = 1}) async {
    String urlPath = "/api/v1/categories/$categoryId";

    try {
      final Uri uri = Uri.parse(API_URL + urlPath);
      await Future.delayed(Duration(seconds: 2));
      var response = await http.get(
        uri,
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer ${DataClient.user.token!}",
        },
      );

      if (response.statusCode == 200) {
        var list = (jsonDecode(response.body)['data']);
        return MapModel.fromJson(list);
      } else {
        print("Error: ${response.statusCode} - ${response.body}");
        return MapModel(id: 0, categoryName: '', lessons: [], createdAt: '', updatedAt: '', deletedAt: '');
      }
    } catch (e) {
      print("Exception: $e");
      return MapModel(id: 0, categoryName: '', lessons: [], createdAt: '', updatedAt: '', deletedAt: '');
    }
  }
}
