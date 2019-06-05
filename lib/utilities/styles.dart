import 'package:flutter/material.dart';

class Styles {
  //Text Styling
  static var textStyle = TextStyle(
      fontFamily: 'Roboto',
      fontWeight: FontWeight.w500,
      color: Colors.black,
      fontSize: 22);

  static var subTextStyle = TextStyle(
      fontFamily: 'Roboto',
      fontWeight: FontWeight.w500,
      color: Colors.black,
      fontSize: 17);

  static var buttonStyle = TextStyle(
      fontFamily: 'Roboto',
      fontWeight: FontWeight.w500,
      color: Colors.white,
      fontSize: 20);

  static var hintStyle = TextStyle(
      fontFamily: 'Roboto',
      fontStyle: FontStyle.italic,
      color: Colors.grey,
      fontSize: 15);

  static var appBarStyle = buttonStyle;


  //Theme
  static var themeData = ThemeData(
      primaryColor: Colors.blueAccent,
      accentColor: Colors.blueAccent,
      appBarTheme: AppBarTheme(
          color: Colors.blueAccent,
          elevation: 5.0,
          iconTheme: IconThemeData(color: Colors.white),
          textTheme: TextTheme(title: appBarStyle)
      ));
}