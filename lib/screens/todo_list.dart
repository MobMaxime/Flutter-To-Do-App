import 'package:flutter/material.dart';
import 'package:to_do/screens/new_task.dart';
import 'dart:async';
import 'package:to_do/models/task.dart';
import 'package:to_do/utilities/database_helper.dart';
import 'package:sqflite/sqflite.dart';
import 'package:to_do/custom widgets/CustomWidget.dart';
import 'package:to_do/utilities/theme_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:to_do/localizations.dart';


class todo extends StatefulWidget {
  final bool darkThemeEnabled;
  todo(this.darkThemeEnabled);

  @override
  State<StatefulWidget> createState() {
    return todo_state();
  }
}

class todo_state extends State<todo> {
  DatabaseHelper databaseHelper = DatabaseHelper();
  List<Task> taskList;
  int count = 0;
  String _themeType;

  @override
  void initState() {
    if (!widget.darkThemeEnabled) {
      _themeType = 'Light Theme';
    } else {
      _themeType = 'Dark Theme';
    }
    super.initState();
  }

  _setPref(bool res) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool('darkTheme', res);
  }


  @override
  Widget build(BuildContext context) {

    if (taskList == null) {
      taskList = List<Task>();
      updateListView();
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context).title(), style: TextStyle(fontSize: 25),),
        actions: <Widget>[
          PopupMenuButton<bool>(
            onSelected: (res) {
              bloc.changeTheme(res);
              _setPref(res);
              setState(() {
                if (_themeType == 'Dark Theme') {
                  _themeType = 'Light Theme';
                } else {
                  _themeType = 'Dark Theme';
                }
              });
            },
            itemBuilder: (context) {
              return <PopupMenuEntry<bool>>[
                PopupMenuItem<bool>(
                  value: !widget.darkThemeEnabled,
                  child: Text(_themeType),
                )
              ];
            },
          )
        ],
      ), //AppBar
      body: Container(
        padding: EdgeInsets.all(8.0),
        child: ListView(
          children: <Widget>[
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.882,
              child: FutureBuilder(
                future: databaseHelper.getTaskList(),
                builder: (BuildContext context, AsyncSnapshot snapshot) {
                  if (snapshot.data == null) {
                    return Text('Loading');
                  } else {
                    if (count < 1) {
                      return Center(
                        child: Text('No Tasks Added', style: TextStyle(fontSize: 20),),
                      );
                    }
                    return ListView.builder(
                        itemCount: count,
                        itemBuilder: (BuildContext context, int position) {
                          return new GestureDetector(
                              onTap: () {
                                if (this.taskList[position].status != "Task Completed")
                                  navigateToTask(this.taskList[position], "Edit Task", this);
                              },
                              child: Card(
                                margin: EdgeInsets.all(1.0),
                                elevation: 2.0,
                                child: CustomWidget(
                                  title: this.taskList[position].task,
                                  sub1: this.taskList[position].date,
                                  sub2: this.taskList[position].time,
                                  status: this.taskList[position].status,
                                  delete: this.taskList[position].status=="Task Completed" ? IconButton(icon: Icon(Icons.delete), onPressed: null, ) : Container(),
                                  trailing: Icon(
                                    Icons.edit,
                                    color: Theme.of(context).primaryColor,
                                    size: 28,
                                  ),
                                ),
                              ) //Card
                          );
                        });
                  }

                },
              ),
            )
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
          tooltip: "Add Task",
          child: Icon(Icons.add),
          onPressed: () {
            navigateToTask(Task('', '', '',''), "Add Task", this);
          }), //FloatingActionButton
    );
  } //build()

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
  } //updateListView()

void delete(){

}
}
