import 'package:sqflite/sqflite.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';

class DBProvider {
  static final DBProvider db = DBProvider();
  static Database? _database;

  final String _dbName = "thisaiveerapandian.db";

  Future<Database> get database async => _database ??= await _initDB();

  _initDB() async {
    String path;
    if (Platform.isIOS) {
      Directory dir = await getLibraryDirectory();
      path = dir.path;
    } else {
      path = await getDatabasesPath();
    }

    return await openDatabase(join(path, _dbName),
        onCreate: (db, version) async {
      try {
        // create Todo table
        await db.execute(
            "CREATE TABLE Todo(id INTEGER PRIMARY KEY, taskname TEXT)");
      } catch (e) {
        print(e.toString());
      }
    }, version: 1);
  }

  // get all tasks in Todo table
  Future<List> getTodoList() async {
    final db = await database;
    var res = await db.query('todo');
    return res;
  }

  // insert task in Todo table
  Future<void> insertTask(taskname) async {
    try {
      final db = await database;
      await db
          .rawInsert("INSERT INTO Todo ('taskname') VALUES (?)", [taskname]);
    } catch (e) {
      return Future.error(e.toString());
    }
  }

  // update task in Todo table
  Future<void> updateTask(id, text) async {
    try {
      final db = await database;
      await db.update('Todo', {'taskname': text},
          where: 'id = ?', whereArgs: [id]);
    } catch (e) {
      return Future.error(e.toString());
    }
  }

  // delete task in Todo table
  Future<void> deleteTask(id) async {
    try {
      final db = await database;
      await db.delete('Todo', where: 'id = ?', whereArgs: [id]);
    } catch (e) {
      return Future.error(e.toString());
    }
  }
}
