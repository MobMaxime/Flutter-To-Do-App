import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class Utils {

  static Utils _utils;
  Utils._createInstance();

  factory Utils() {
    if (_utils == null) {
      _utils = Utils._createInstance();
    }
    return _utils;
  }

  void showAlertDialog(
      BuildContext context, String title, String message) {
    AlertDialog alertDialog = AlertDialog(
      title: Text(title),
      content: Text(message),
    );

    showDialog(context: context, builder: (_) => alertDialog);
  }

  void showSnackBar(var scaffoldkey, String message) {
    final snackBar = SnackBar(
      content: Text(message),
      duration: Duration(seconds: 1, milliseconds: 500),
    );
    scaffoldkey.currentState.showSnackBar(snackBar);
  }

  Future<String> selectDate(BuildContext context, String date) async {
    final DateTime picked = await showDatePicker(
        context: context,
        firstDate: DateTime.now(),
        initialDate: date.isEmpty
            ? DateTime.now()
            : new DateFormat("d MMM, y").parse(date),
        lastDate: DateTime(2021));
        if (picked != null)
          return formatDate(picked);

    return "";
  }

  Future<String> selectTime(BuildContext context) async {
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
    if (picked != null){
      return timeFormat(picked);
    }

    return "";
  }


  String timeFormat(TimeOfDay picked){

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

    return h + ":" + m + " " + Time;
  }
  String formatDate(DateTime selectedDate) =>
      new DateFormat("d MMM, y").format(selectedDate);
}
