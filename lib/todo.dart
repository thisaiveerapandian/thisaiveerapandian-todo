import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:thisaiveerapandian_todo/utils/provider.dart';

final todoProvider =
    ChangeNotifierProvider.autoDispose<TodoClient>((ref) => TodoClient());

class Todo extends StatefulWidget {
  @override
  createState() => TodoPage();
}

class TodoPage extends State<Todo> {
  bool enableErrorText = false;
  TextEditingController textController = TextEditingController();

  @override
  void initState() {
    super.initState();
    //get all todo data
    context.read(todoProvider).gettodoList();
  }

  // add/update task name
  _inputDialog(BuildContext context, title, data) async {
    return showDialog(
        context: context,
        builder: (context) {
          return StatefulBuilder(builder: (context, StateSetter setState) {
            return AlertDialog(
              title: Text(title),
              content: TextField(
                  controller: textController,
                  onChanged: (value) {
                    if (value == '')
                      setState(() {
                        enableErrorText = true;
                      });
                    else
                      setState(() {
                        enableErrorText = false;
                      });
                  },
                  keyboardType: TextInputType.multiline,
                  maxLength: null,
                  maxLines: null,
                  decoration: new InputDecoration(
                      errorText:
                          enableErrorText ? 'Task name cannot be blank' : null,
                      border: new OutlineInputBorder(
                          borderSide: new BorderSide(color: Colors.teal)))),
              actions: <Widget>[
                Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      new ElevatedButton(
                        child: new Text('Cancel'),
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      new ElevatedButton(
                        child: new Text('Save'),
                        onPressed: () {
                          if (textController.text.trim() == '') {
                            setState(() {
                              enableErrorText = true;
                            });
                          } else {
                            if (title == 'Add new task')
                              context
                                  .read(todoProvider)
                                  .addnewTask(textController.text.trim());
                            else
                              context.read(todoProvider).updateTask(
                                  data['id'], textController.text.trim());
                            Navigator.of(context).pop();
                            setState(() {
                              enableErrorText = false;
                            });
                          }
                        },
                      )
                    ])
              ],
            );
          });
        });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Consumer(
          builder: (context, watch, child) {
            final todoList = watch(todoProvider);
            if (todoList.todolist.length != 0) {
              return Expanded(
                child: ListView.builder(
                    itemCount: todoList.todolist.length,
                    itemBuilder: (BuildContext context, int index) {
                      return Card(
                        shadowColor: Colors.black45,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15.0),
                            side: BorderSide(
                              color: Colors.grey,
                              width: 1,
                            )),
                        margin: EdgeInsets.only(bottom: 10),
                        child: todoList.todolist[index]['taskname'] != null
                            ? ListTile(
                                contentPadding: EdgeInsets.all(10),
                                onTap: () {
                                  textController = TextEditingController(
                                      text: todoList.todolist[index]
                                          ['taskname']);
                                  _inputDialog(context, 'Update task name',
                                      todoList.todolist[index]);
                                },
                                title:
                                    Text(todoList.todolist[index]['taskname']),
                                trailing: IconButton(
                                  icon: const Icon(Icons.delete),
                                  onPressed: () {
                                    context.read(todoProvider).deleteTask(
                                        todoList.todolist[index]['id']);
                                  },
                                ),
                              )
                            : null,
                      );
                    }),
              );
            } else {
              return Container();
            }
          },
        ),
        ElevatedButton(
          style: ButtonStyle(
              shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                  RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18.0),
          ))),
          onPressed: () {
            textController = TextEditingController(text: "");
            _inputDialog(context, 'Add new task', '');
          },
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.add),
              Text('add task'),
            ],
          ),
        )
      ],
    );
  }
}
