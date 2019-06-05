import 'package:flutter/material.dart';
import 'package:to_do/utilities/database_helper.dart';
import 'package:to_do/models/task.dart';
import 'package:to_do/screens/todo_list.dart';
import 'package:to_do/utilities/styles.dart';
import 'package:to_do/utilities/utils.dart';

class new_task extends StatefulWidget {
  final String appBarTitle;
  final Task task;
  todo_state todoState;
  new_task(this.task, this.appBarTitle, this.todoState);
  bool _isEditable = false;

  @override
  State<StatefulWidget> createState() {
    return task_state(this.task, this.appBarTitle, this.todoState);
  }
}

class task_state extends State<new_task> {
  todo_state todoState;
  String appBarTitle;
  Task task;
  List<Widget> icons;

  final scaffoldkey = GlobalKey<ScaffoldState>();

  DatabaseHelper helper = DatabaseHelper();
  Utils utility = new Utils();
  TextEditingController taskController = new TextEditingController();

  var formattedDate = "Pick Date";
  var formattedTime = "Select Time";
  var _minPadding = 10.0;
  DateTime selectedDate = DateTime.now();
  TimeOfDay selectedTime = TimeOfDay();

  task_state(this.task, this.appBarTitle, this.todoState);

  @override
  Widget build(BuildContext context) {
    TextStyle textStyle = Styles.textStyle;
    TextStyle hintStyle = Styles.hintStyle;
    TextStyle buttonStyle = Styles.buttonStyle;
    TextStyle subTextStyle = Styles.subTextStyle;

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
          title: Text(appBarTitle),
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
            title: task.date.isEmpty
                ? Text(
                    "Pick Date",
                    style: subTextStyle,
                  )
                : Text(task.date),
            subtitle: Text(""),
            trailing: Icon(Icons.calendar_today),
            onTap: () async {
              var pickedDate = await utility.selectDate(context, task.date);
              if (pickedDate != null && !pickedDate.isEmpty)
                setState(() {
                  formattedDate = pickedDate.toString();
                  task.date = formattedDate;
                });
            },
          ), //DateListTile

          ListTile(
            title: task.time.isEmpty
                ? Text(
                    "Select Time",
                    style: subTextStyle,
                  )
                : Text(task.time),
            subtitle: Text(""),
            trailing: Icon(Icons.access_time),
            onTap: () async {
              var pickedTime = await utility.selectTime(context);
              if (pickedTime != null && !pickedTime.isEmpty)
                setState(() {
                  formattedTime = pickedTime;
                  task.time = formattedTime;
                });
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
              elevation: 5.0,
              child: Text(
                "Save",
                style: buttonStyle,
                textAlign: TextAlign.center,
                textScaleFactor: 1.2,
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
                    elevation: 5.0,
                    child: Text(
                      "Delete",
                      style: buttonStyle,
                      textAlign: TextAlign.center,
                      textScaleFactor: 1.2,
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
    if (this.appBarTitle == "Add Task")
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
      utility.showSnackBar(scaffoldkey, 'Task cannot be empty');
      res = false;
    } else if (task.date.isEmpty) {
      utility.showSnackBar(scaffoldkey, 'Please select the Date');
      res = false;
    } else if (task.time.isEmpty) {
      utility.showSnackBar(scaffoldkey, 'Please select the Time');
      res = false;
    } else {
      res = true;
    }
    return res;
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
        utility.showAlertDialog(context, 'Status', 'Task saved successfully.');
      } else {
        utility.showAlertDialog(context, 'Status', 'Problem saving task.');
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
                  utility.showSnackBar(
                      scaffoldkey, 'Task Deleted Successfully.');
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
