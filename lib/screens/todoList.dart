import 'package:flutter/material.dart';
import 'package:to_do/screens/new_task.dart';
import 'dart:async';
import 'package:to_do/models/task.dart';
import 'package:to_do/utilities/database_helper.dart';
import 'package:sqflite/sqflite.dart';
import 'package:to_do/utilities/CustomWidget.dart';

class todo extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return todo_state();
  }
}

class todo_state extends State<todo> {
  DatabaseHelper databaseHelper = DatabaseHelper();
  List<Task> taskList;
  int count = 0;
  todo_state();

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
            navigateToTask(Task('', '', ''), "Add Task", this);
          }), //FloatingActionButton
    );
  }

//  ListView getListView() {
//    return ListView.builder(
//        itemCount: count,
//        itemBuilder: (BuildContext context, int position) {
//          return Card(
//            elevation: 2.0,
//            color: Colors.white,
//            child: ListTile(
//              title: Text(this.taskList[position].task),
//              subtitle: Text(this.taskList[position].date),
//              trailing: Icon((Icons.arrow_forward), color: Theme.of(context).primaryColor, size: 30,),
////              CircleAvatar(
////                backgroundColor: Theme.of(context).primaryColor,
////                child: Icon(Icons.arrow_forward_ios, color: Colors.white),
////              ),
//              onTap: () {
//                nagivateToTask(
//                    this.taskList[position], "Edit Task", this);
//              },
//            ), //ListTile
//          ); //Card
//        });
//  } //getListView()


    ListView getListView() {
    return ListView.builder(
        itemCount: count,
        itemBuilder: (BuildContext context, int position) {
          return new GestureDetector(
              onTap: () {
                navigateToTask(
                  this.taskList[position],"Edit Task", this);
              },
              child: Card(
            margin: EdgeInsets.all(5.0),
            elevation: 2.0,
            color: Colors.white,
            child: CustomWidget(
            title: this.taskList[position].task,
            sub1: this.taskList[position].date,
            sub2: this.taskList[position].time,
              trailing: Icon(
                  Icons.edit,
                  color: Theme.of(context).primaryColor,
                  size: 28,
                ),
          ),


          ) //Card
          );
        });
  } //getListView()

//  ListView getListView() {
//    return ListView.builder(
//        itemCount: count,
//        itemBuilder: (BuildContext context, int position) {
//          return CustomWidget(
//            title: this.taskList[position].task,
//            sub1: this.taskList[position].date,
//            sub2: this.taskList[position].time,
//          );
//        });
//  } //g

  //Delete Task
//  void _delete(BuildContext context, Task task) async {
//    int result = await databaseHelper.deleteTask(task.id);
//    if (result != 0) {
//      _showSnackBar(context, 'Task Deleted Successfully!');
//      updateListView();
//    }
//  }


  void navigateToTask(Task task, String title, todo_state obj) async {
    bool result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => new_task(task, title, obj)),
    );
    if (result == true) {
      updateListView();
    }
  }

  void updateListView() {
    final Future<Database> dbFuture = databaseHelper.initializeDatabase();
    dbFuture.then((database) {
      Future<List<Task>> taskListFuture = databaseHelper.getTaskList();
      taskListFuture.then((taskList) {
        setState(() {
          this.taskList = taskList;
          this.count = taskList.length;
        });
      });
    });
  }
}
