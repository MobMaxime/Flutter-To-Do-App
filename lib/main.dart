import 'package:flutter/material.dart';
import 'package:to_do/screens/todo_list.dart';
import 'classes/theme_data.dart';
import 'package:to_do/utilities/theme_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:to_do/localizations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

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
      builder: (context, snapshot) {
        if (snapshot.data == null) {
          return MaterialApp(
            onGenerateTitle: (BuildContext context) =>
                AppLocalizations.of(context).title(),
            localizationsDelegates: [
              const AppLocalizationsDelegate(),
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
            ],
            supportedLocales: [
              const Locale('en', ''),
              const Locale('de', ''),
              const Locale('ru', ''),
            ],
            home: Scaffold(
              body: Center(
                child: Text("Loading"),
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
                      child: Text(AppLocalizations.of(context).loadData()),
                    ),
                  ),
                );
              } else {
                return MaterialApp(
                  onGenerateTitle: (BuildContext context) =>
                      AppLocalizations.of(context).title(),
                  localizationsDelegates: [
                    const AppLocalizationsDelegate(),
                    GlobalMaterialLocalizations.delegate,
                    GlobalWidgetsLocalizations.delegate,
                  ],
                  supportedLocales: [
                    const Locale('en', ''),
                    const Locale('de', ''),
                    const Locale('ru', ''),
                  ],
                  debugShowCheckedModeBanner: false,
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