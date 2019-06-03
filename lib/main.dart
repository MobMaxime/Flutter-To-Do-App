import 'package:flutter/material.dart';
import 'package:to_do/screens/todoList.dart';

void main() {
  runApp(
    new MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "My To-Do List",
      home: todo(),
      theme: ThemeData(
          primaryColor: Colors.blue,
          accentColor: Colors.blueAccent,
          brightness: Brightness.light),
    ),
  );
}





