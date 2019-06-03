import 'package:flutter/material.dart';
import 'dart:async';
import 'package:intl/intl.dart';
import 'package:to_do/utilities/database_helper.dart';
import 'package:to_do/models/task.dart';
import 'package:to_do/screens/todoList.dart';

class new_task extends StatefulWidget {
  final String appBartitle;
  final Task task;
  final List<Task> taskList;
  new_task(this.task, this.appBartitle, this.taskList);

  @override
  State<StatefulWidget> createState() {
    return task_state(this.task, this.appBartitle, this.taskList);
  }
}

class task_state extends State<new_task> {
  todo_state todoState;
  List<Task> taskList;
  String appBartitle;
  Task task;

  DatabaseHelper helper = DatabaseHelper();
  TextEditingController taskController = new TextEditingController();

  var formattedDate = "Pick Date";
  var formattedTime = "Select Time";
  var _minPadding = 10.0;
  DateTime _initialDate = DateTime.now();
  DateTime selectedDate = DateTime.now();
  TimeOfDay selectedTime = TimeOfDay();

  task_state(this.task, this.appBartitle, this.taskList);

  String formatDate(DateTime selectedDate) =>
      new DateFormat("d MMM, y").format(selectedDate);

  String formatTime(TimeOfDay selectedTime) {}

  Future<Null> _selectDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: _initialDate,
        firstDate: _initialDate,
        lastDate: DateTime(2021));
    if (picked != null && picked != selectedDate)
      setState(() {
        formattedDate = formatDate(picked);
      });
  }

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
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

        var time = h + " : " + m + "  " + Time;
        setState(() {
          formattedTime = time;
        });
      });
  }

  @override
  Widget build(BuildContext context) {
    TextStyle textStyle = Theme.of(context).textTheme.title;
    TextStyle hintStyle =
        TextStyle(fontStyle: FontStyle.italic, color: Colors.grey);
    //TextStyle hstyle = hintStyle;

    taskController.text = task.task;
    return Scaffold(
        appBar: AppBar(
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
                    //border: OutlineInputBorder(borderRadius: BorderRadius.zero),
                    labelStyle: textStyle,
                    hintStyle: hintStyle), //Input Decoration
                onChanged: (value) {
                  updateTask();
                }), //TextFormField
          ), //Padding

          ListTile(
            title: Text("$formattedDate"),
            subtitle: Text(""),
            trailing: Icon(Icons.calendar_today),
            onTap: () {
              _selectDate(context);
              updateDate();
            },
          ), //DateListTile

          ListTile(
            title: Text("$formattedTime"),
            subtitle: Text(""),
            trailing: Icon(Icons.access_time),
            onTap: () {
              _selectTime(context);
              updateTime();
            },
          ), //TimeListTile

//        SizedBox.fromSize(
//          size: Size(30.0, 30.0),
//        ),

//          ListTile(
//            title: Text("Add to List"),
//            subtitle: Text(""),
//            trailing: Icon(Icons.add),
//            onTap: () {},
//          ), //AddToList Tile

          Padding(
              padding: EdgeInsets.all(_minPadding),
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: RaisedButton(
                      //shape: RoundedRectangleBorder(
                      //  borderRadius: BorderRadius.circular(10.0)),
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
                  ),
                  Container(
                    child: SizedBox(width: 10.0),
                  ),
                  Expanded(
                    child: RaisedButton(
                      //shape: RoundedRectangleBorder(
                      //  borderRadius: BorderRadius.circular(10.0)),
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
                    ), //RaisedButton
                  )
                ],
              ) //Row
              ) //Padding

//            Center(
//              child: DropdownButton<String>(
//                items: _repeat.map((String dropDownStringItem) {
//                  return DropdownMenuItem<String>(
//                    value: dropDownStringItem,
//                    child: Text(
//                      dropDownStringItem,
//                      style: TextStyle(
//                        fontSize: 20.0,
//                        color: Colors.white,
//                      ),
//                    ),
//                  );
//                }).toList(),
//                value: _repeatSelected,
//                onChanged: (String newValueSelected) {
//                  //code
//                  setState(() {
//                    this._repeatSelected = newValueSelected;
//                  });
//                },
//              ), //DropdownButton
//            )
        ]) //ListView

        ); //Scaffold
  } //build()

  void updateTask() {
    task.task = taskController.text;
  }

  void updateDate() {
    task.date = formattedDate;
  }

  void updateTime() {
    task.time = formattedTime;
  }

  //Save data
  void _save() async {
    Navigator.pop(context);
    int result;
    if (task.id != null) {
      //Update Operation
      result = await helper.updateTask(task);
    } else {
      //Insert Operation
      result = await helper.insertTask(task);
    }

    todoState.updateListView();

    if (result != 0) {
      _showAlertDialog('Status', 'Task saved successfully.');

    } else {
      _showAlertDialog('Status', 'Problem saving task.');
    }
  } //_save()

//  void _delete(BuildContext context, Task task) async {
//    int result = await databaseHelper.deleteTask(task.id);
//    if (result != 0) {
//      _showSnackBar(context, 'Task Deleted Successfully!');
//      updateListView();
//    }
//  }

  void _delete() async {
    Navigator.pop(context);

    if (task.id == null) {
      _showAlertDialog('Status', 'No Task was Created');
      return;
    }

    int result = await helper.deleteTask(task.id);
    print("afte ..................................................... delete");
    todoState.updateListView();
    if (result != 0) {
      _showAlertDialog('Status', 'Task Deleted Successfully.');
    } else {
      _showAlertDialog('Status', 'Error occured while Deleting Task');
    }
  } //_delete()

  void _showAlertDialog(String title, String message) {
    AlertDialog alertDialog = AlertDialog(
      title: Text(title),
      content: Text(message),
    );

    showDialog(context: context, builder: (_) => alertDialog);
  }
} //class task_state
