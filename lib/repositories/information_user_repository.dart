import 'dart:async';
import 'package:english_learning_app/models/user_model.dart';
import 'package:english_learning_app/service/database_service.dart';
import 'package:sqflite/sqflite.dart';

class InformationUserRepository {
  static Future<bool> addCustomer(UserModel infor) async {
    var dbClient = await (DatabaseService.db);
    await dbClient!.insert("InformationUser", infor.toJson(), conflictAlgorithm: ConflictAlgorithm.replace);
    return true;
  }

  static Future<dynamic> get(id) async {
    var dbClient = await (DatabaseService.db);
    List<Map> records = await dbClient!.rawQuery("SELECT * FROM InformationUser where id ='" + id.toString() + "'");
    if (records.length > 0) {
      return records[0];
    }
    return null;
  }

  static Future<UserModel?> getByToken(token) async {
    var dbClient = await (DatabaseService.db);
    List<Map> records = await dbClient!.rawQuery("SELECT * FROM InformationUser where token ='" + token.toString() + "'");
    if (records.length > 0) {
      // Lấy thông tin lastLesson nếu có
      LastLesson? lastLesson;
      if (records[0]['last_lesson'] != null) {
        try {
          Map<String, dynamic> lastLessonMap = Map<String, dynamic>.from(records[0]['last_lesson']);
          lastLesson = LastLesson.fromJson(lastLessonMap);
        } catch (e) {
          print("Error parsing lastLesson: $e");
          lastLesson = null;
        }
      }

      return UserModel(
        // Các trường cơ bản đã có
        username: records[0]['user_name'],
        created_at: records[0]['created_at'],
        phone: records[0]['phone'],
        urlAvatar: records[0]['urlAvatar'],
        id: records[0]['id'],
        email: records[0]['email'],
        streak: records[0]['streak'],
        heart: records[0]['heart'],

        // Bổ sung các trường còn lại từ UserModel
        role: records[0]['role'],
        completedLessons: records[0]['completedLessons'],
        progress: records[0]['progress'],
        language: records[0]['language'],
        gem: records[0]['gem'],
        xp: records[0]['xp'],
        lastCompletionDate: records[0]['lastCompletionDate'],

        // Thêm các trường mới được bổ sung
        lastLesson: lastLesson,
        total_lessons: records[0]['total_lessons'],
        total_score: records[0]['total_score'],
      );
    }
    return null;
  }
}
