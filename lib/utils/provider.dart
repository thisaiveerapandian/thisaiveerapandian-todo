import 'package:flutter/foundation.dart';
import 'package:thisaiveerapandian_todo/utils/database.dart';

class TodoClient extends ChangeNotifier {
  final _db = DBProvider.db;

  List _todolist = [];
  List get todolist => _todolist;

  // get all todo data
  Future<void> gettodoList() async {
    var res = await _db.getTodoList();
    if (res.length != 0) _todolist = res;
    notifyListeners();
  }

  // add new task in local db
  void addnewTask(taskname) async {
    await _db.insertTask(taskname);
    gettodoList();
  }

  // update task in local db
  void updateTask(id, text) async {
    await _db.updateTask(id, text);
    gettodoList();
  }

  // delete task in local db
  void deleteTask(id) async {
    await _db.deleteTask(id);
    gettodoList();
  }
}
