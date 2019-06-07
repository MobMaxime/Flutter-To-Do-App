import 'package:flutter/material.dart';

class Themes {

  static ThemeData light = ThemeData(
    fontFamily: 'Lato',
    brightness: Brightness.light,
    accentColor: Color(0xff2150c4),
    primaryColor: Color(0xff2150c4),
  );
  static ThemeData dark = ThemeData(
    fontFamily: 'Lato',
    brightness: Brightness.dark,
    accentColor: Color(0xff8349eb),
    primaryColor: Color(0xff8349eb),
    backgroundColor: Color(0xff130528),
    cardColor: Color(0xff424242),
  );
}
