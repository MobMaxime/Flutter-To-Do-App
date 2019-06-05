import 'package:flutter/material.dart';
import 'dart:async';
import 'package:intl/intl.dart';
import 'package:to_do/utilities/database_helper.dart';
import 'package:to_do/models/task.dart';
import 'package:to_do/screens/todoList.dart';
import 'package:to_do/utilities/Utils.dart';

class new_task extends StatefulWidget {
  final String appBartitle;
  final Task task;
  todo_state todoState;
  new_task(this.task, this.appBartitle, this.todoState);
  bool _isEditable = false;

  @override
  State<StatefulWidget> createState() {
    return task_state(this.task, this.appBartitle, this.todoState);
  }
}

class task_state extends State<new_task> {
  todo_state todoState;
  String appBartitle;
  Task task;
  List<Widget> icons;

  final scaffoldkey = GlobalKey<ScaffoldState>();

  DatabaseHelper helper = DatabaseHelper();
  TextEditingController taskController = new TextEditingController();

  var formattedDate = "Pick Date";
  var formattedTime = "Select Time";
  var _minPadding = 10.0;
  DateTime _initialDate = DateTime.now();
  DateTime selectedDate = DateTime.now();
  TimeOfDay _initialTime = TimeOfDay.now();
  TimeOfDay selectedTime = TimeOfDay();

  task_state(this.task, this.appBartitle, this.todoState);

  String formatDate(DateTime selectedDate) =>
      new DateFormat("d MMM, y").format(selectedDate);

  Future<Null> _selectDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
        context: context,
        firstDate: _initialDate,
        initialDate: task.date.isEmpty
            ? _initialDate
            : new DateFormat("d MMM, y").parse(task.date),
        lastDate: DateTime(2021));
    if (picked != null && picked != selectedDate)
      setState(() {
        formattedDate = formatDate(picked);
        task.date = formattedDate;
      });
  }

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
      //initialTime: task.time.isEmpty ? _initialTime : new TimeOfDay().parse(task.time),
      builder: (BuildContext context, Widget child) {
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: false),
          child: child,
        );
      },
    );
    if (picked != null && picked != selectedTime)
      setState(() {
        var hour = 00;
        var Time = "PM";
        if (picked.hour >= 12) {
          Time = "PM";
          if (picked.hour > 12) {
            hour = picked.hour - 12;
          } else if (picked.hour == 00) {
            hour = 12;
          } else {
            hour = picked.hour;
          }
        } else {
          Time = "AM";
          if (picked.hour == 00) {
            hour = 12;
          } else {
            hour = picked.hour;
          }
        }
        var h, m;
        if (hour % 100 < 10) {
          h = "0" + hour.toString();
        } else {
          h = hour.toString();
        }

        int minute = picked.minute;
        if (minute % 100 < 10)
          m = "0" + minute.toString();
        else
          m = minute.toString();

        var time = h + ":" + m + " " + Time;
        setState(() {
          formattedTime = time;
          task.time = formattedTime;
        });
      });
  }

  @override
  Widget build(BuildContext context) {
    TextStyle textStyle = Theme.of(context).textTheme.title;
    TextStyle hintStyle =
        TextStyle(fontStyle: FontStyle.italic, color: Colors.grey);

    taskController.text = task.task;
    return Scaffold(
        key: scaffoldkey,
        appBar: AppBar(
          leading: new GestureDetector(
            child: Icon(Icons.close, size: 30),
            onTap: () {
              Navigator.pop(context);
            },
          ),
          title: Text(
            appBartitle,
            style: TextStyle(color: Colors.white),
          ),
          backgroundColor: Colors.blue,
        ),
        body: ListView(children: <Widget>[
          Padding(
            padding: EdgeInsets.all(_minPadding),
            child: TextField(
                controller: taskController,
                decoration: InputDecoration(
                    labelText: "Task",
                    hintText: "E.g.  Pick Julie from School",
                    labelStyle: textStyle,
                    hintStyle: hintStyle), //Input Decoration
                onChanged: (value) {
                  updateTask();
                }), //TextField
          ), //Padding

          ListTile(
            title: task.date.isEmpty ? Text("Pick Date") : Text(task.date),
            subtitle: Text(""),
            trailing: Icon(Icons.calendar_today),
            onTap: () {
              _selectDate(context);
            },
          ), //DateListTile

          ListTile(
            title: task.time.isEmpty ? Text("Select Time") : Text(task.time),
            subtitle: Text(""),
            trailing: Icon(Icons.access_time),
            onTap: () {
              _selectTime(context);
            },
          ), //TimeListTile

          Padding(
            padding: EdgeInsets.all(_minPadding),
            child: RaisedButton(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(50.0)),
              padding: EdgeInsets.all(_minPadding / 2),
              color: Theme.of(context).primaryColor,
              textColor: Colors.white,
              elevation: 6.0,
              child: Text(
                "Save",
                textAlign: TextAlign.center,
                textScaleFactor: 1.7,
              ),
              onPressed: () {
                setState(() {
                  _save();
                });
              },
            ), //RaisedButton
          ), //Padding

          Padding(
            padding: EdgeInsets.all(_minPadding),
            child: _isEditable()
                ? RaisedButton(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(50.0)),
                    padding: EdgeInsets.all(_minPadding / 2),
                    color: Theme.of(context).primaryColor,
                    textColor: Colors.white,
                    elevation: 6.0,
                    child: Text(
                      "Delete",
                      textAlign: TextAlign.center,
                      textScaleFactor: 1.7,
                    ),
                    onPressed: () {
                      setState(() {
                        _delete();
                      });
                    },
                  ) //RaisedButton
                : Container(),
          ) //Padding
        ]) //ListView

        ); //Scaffold
  } //build()

  bool _isEditable() {
    if (this.appBartitle == "Add Task")
      return false;
    else {
      return true;
    }
  }

  void updateTask() {
    task.task = taskController.text;
  }

  //InputConstraints
  bool _checkNotNull() {
    bool res;
    if (taskController.text.isEmpty) {
      _showSnackBar('Task cannot be empty');
      res = false;
    } else if (task.date.isEmpty) {
      _showSnackBar('Please select the Date');
      res = false;
    } else if (task.time.isEmpty) {
      _showSnackBar('Please select the Time');
      res = false;
    } else {
      res = true;
    }
    return res;
  }

  void _showSnackBar(String message) {
    final snackBar = SnackBar(
      content: Text(message),
      duration: Duration(seconds: 1, milliseconds: 500),
    );
    scaffoldkey.currentState.showSnackBar(snackBar);
  }

  //Save data
  void _save() async {
    int result;
    if (_checkNotNull() == true) {
      if (task.id != null) {
        //Update Operation
        result = await helper.updateTask(task);
      } else {
        //Insert Operation
        result = await helper.insertTask(task);
      }
      print("result is :  $result");
      todoState.updateListView();

      Navigator.pop(context);

      if (result != 0) {
        Utils.showAlertDialog(context, 'Status', 'Task saved successfully.');
      } else {
        Utils.showAlertDialog(context, 'Status', 'Problem saving task.');
      }
    }
  } //_save()

  void _delete() {
    int result;
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Are you sure, you want to delete this task?"),
            actions: <Widget>[
              RawMaterialButton(
                onPressed: () async {
                  await helper.deleteTask(task.id);
                  todoState.updateListView();
                  Navigator.pop(context);
                  Navigator.pop(context);
                  _showSnackBar('Task Deleted Successfully.');
                },
                child: Text("Yes"),
              ),
              RawMaterialButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text("No"),
              )
            ],
          );
        });
  }
} //class task_state
