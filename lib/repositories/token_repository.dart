import 'dart:async';
import 'package:english_learning_app/service/database_service.dart';
import 'package:sqflite/sqflite.dart';
import '../models/database/token.dart';

class TokenRepository {
  static Future<bool> add(Token token) async {
    var dbClient = await (DatabaseService.db);
    await dbClient!.insert("Token", token.toJson(), conflictAlgorithm: ConflictAlgorithm.replace);
    return true;
  }

  static Future<Token> getByName(name) async {
    var dbClient = await (DatabaseService.db);
    List<Map> records = await dbClient!.rawQuery("SELECT * FROM Token where name ='" + name + "'");
    Token token = Token();
    for (var record in records) {
      token = Token.fromJson(record as Map<String, dynamic>);
    }
    return token;
  }
}
