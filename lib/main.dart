import 'package:flutter/material.dart';
import 'package:to_do/screens/todo_list.dart';
import 'classes/theme_data.dart';
import 'package:to_do/utilities/theme_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

final routeObserver = RouteObserver<PageRoute>();

void main() {
  runApp(
     new MyApp()
    );
}

class MyApp extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _getTheme(),
      builder: (builder, snapshot) {
        if (snapshot.data == null) {
          return MaterialApp(
            home: Scaffold(
              body: Center(
                child: Text('Loading'),
              ),
            ),
          );
        } else {
          return StreamBuilder(
            stream: bloc.darkThemeEnabled,
            initialData: snapshot.data,
            builder: (context, snapshot) {
              if (snapshot.data == null) {
                return MaterialApp(
                  home: Scaffold(
                    body: Center(
                      child: Text('Loading Data'),
                    ),
                  ),
                );
              } else {
                return MaterialApp(
                  debugShowCheckedModeBanner: false,
                  title: 'My To-Do List',
                  theme: snapshot.data ? Themes.light : Themes.dark,
                  navigatorObservers: [routeObserver],
                  home: todo(snapshot.data),
                );
              }
            },
          );
        }
      },
    );
  }

  _getTheme() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool val = prefs.getBool('darkTheme');
    if(val == null){
      val = true;
    }
    return val;
  }
}