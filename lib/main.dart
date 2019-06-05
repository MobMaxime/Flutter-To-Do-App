import 'package:flutter/material.dart';
import 'package:to_do/screens/todo_list.dart';
import 'package:to_do/utilities/styles.dart';
void main() {
  runApp(
    new MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "My To-Do List",
      home: todo(),
      theme: Styles.themeData
    ),
  );
}
