import 'dart:async';
import 'dart:io' as io;
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';
import 'package:ampluserv/models/ampUserModel.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = new
  DatabaseHelper.internal();
  factory DatabaseHelper() => _instance;

  static Database _db;

  Future<Database> get db async {
    if(_db != null)
      return _db;
    _db = await initDb();
    return _db;
  }

  DatabaseHelper.internal();

  initDb() async {
    io.Directory documentsDirectory = await
    getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, "main.db");
    var theDb = await openDatabase(path, version: 2, onCreate:
    _onCreate);
    return theDb;
  }


  void _onCreate(Database db, int version) async {
    // When creating the db, create the table
    await db.execute(
        "CREATE TABLE User(id INT, username TEXT, name TEXT, userid TEXT, client_type TEXT, userlevel TEXT, email TEXT, api_token TEXT, phone TEXT)");
    print("Created tables");
  }

  Future<int> saveUser(chcUserModel user) async {
    var dbClient = await db;
    int res = await dbClient.insert("User", user.toMap());
    return res;
  }

  Future<int> deleteUsers() async {
    var dbClient = await db;
    int res = await dbClient.delete("User");
    return res;
  }

  Future<bool> isLoggedIn() async {
    var dbClient = await db;
    var res = await dbClient.query("User");
    return res.length > 0? true: false;
  }

  Future<chcUserModel> getClient() async {
    var dbClient = await db;
    var res = await dbClient.query("User");
    if (res.length > 0) {
      return new chcUserModel.fromMap(res.first);
    }
    return null;
  }
}