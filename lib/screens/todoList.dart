import 'package:flutter/material.dart';
import 'package:to_do/screens/new_task.dart';
import 'dart:async';
import 'package:to_do/models/task.dart';
import 'package:to_do/utilities/database_helper.dart';
import 'package:sqflite/sqflite.dart';

class todo extends StatefulWidget {
  int count = 0;

  @override
  State<StatefulWidget> createState() {
    return todo_state();
  }
}

class todo_state extends State<todo> {
  int count = 0;
  DatabaseHelper databaseHelper = DatabaseHelper();
  List<Task> taskList;

  @override
  Widget build(BuildContext context) {
    if (taskList == null) {
      taskList = List<Task>();
      updateListView();
    }

    return Scaffold(
      appBar: AppBar(
        title: Text("TO-DO"),
      ), //AppBar
      body: getListView(),

      floatingActionButton: FloatingActionButton(
          tooltip: "Add Task",
          child: Icon(Icons.add),
          onPressed: () {
            nagivateToTask(Task('', '', ''), "Add Task", taskList);
          }), //FloatingActionButton
    );
  }

  ListView getListView() {
    return ListView.builder(
        itemCount: count,
        itemBuilder: (BuildContext context, int position) {
          return Card(
            elevation: 2.0,
            color: Colors.white,
            child: ListTile(
              leading: CircleAvatar(
                backgroundColor: Theme.of(context).primaryColor,
                child: Icon(Icons.arrow_forward_ios, color: Colors.white),
              ),
              title: Text(this.taskList[position].task),
              subtitle: Text(this.taskList[position].date),
              trailing: GestureDetector(
                  child: Icon(Icons.delete, color: Colors.grey),
                  onTap: () {
                    _delete(context, taskList[position]);
                  }), //Gesture Detector
              onTap: () {
                nagivateToTask(
                    this.taskList[position], "Edit Task", this.taskList);
              },
            ), //ListTile
          ); //Card
        });
  } //getListView()

  //Delete Task
  void _delete(BuildContext context, Task task) async {
    int result = await databaseHelper.deleteTask(task.id);
    if (result != 0) {
      _showSnackBar(context, 'Task Deleted Successfully!');
      updateListView();
    }
  }

  void _showSnackBar(BuildContext context, String message) {
    final snackBar = SnackBar(
      content: Text(message),
    );
    Scaffold.of(context).showSnackBar(snackBar);
  }

  void nagivateToTask(Task task, String title, List<Task> taskList) async {
    bool result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => new_task(task, title, taskList)),
    );
    if (result == true) {
      updateListView();
    }
  }

  void updateListView() {
    print("update started..............................");
    final Future<Database> dbFuture = databaseHelper.initializeDatabase();
    dbFuture.then((database) {
      Future<List<Task>> taskListFuture = databaseHelper.getTaskList();
      taskListFuture.then((tasklist) {
        setState(() {
          this.taskList = taskList;
          this.count = taskList.length;
        });
      });
    });
    print("update ended..............................");
  }
}
