import 'dart:io' as io;

import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

import '../utils/query.dart';

class DatabaseService {
  static Database? _db;

  static Future<Database?> get db async {
    if (_db != null) return _db;
    _db = await initDb();
    return _db;
  }

  static initDb() async {
    io.Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, "learnEngApp.db");
    var theDb = await openDatabase(path, version: 1, onCreate: _onCreate, onUpgrade: _onUpgrade);
    //"version":update database version increase by 1
    return theDb;
  }

  static void _onUpgrade(Database db, int oldVersion, int newVersion) {
    if (oldVersion < newVersion) {
      for (int version = oldVersion + 1; version <= newVersion; version++) {
        if (version == 2) {}
        if (version == 3) {}
        if (version == 4) {}
      }
    }
  }

  static void _onCreate(Database db, int version) async {
    await db.execute(Query.createTableToken);
    await db.execute(Query.createTableSetting);
    await db.execute(Query.createTableUser);

  }

  static Future<void> deleteALL(String tableName) async {
    var dbClient = await (DatabaseService.db);
    await dbClient!.rawDelete('DELETE FROM ' + tableName);
  }

  static Future<void> removeAllData() async {
    var dbClient = await DatabaseService.db;
    List<String> listTable = [];
    listTable.forEach((tableName) async {
      try {
        await dbClient!.rawDelete('DELETE FROM ' + tableName);
      } catch (ignore) {}
    });
  }
}
