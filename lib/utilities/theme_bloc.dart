import 'dart:async';

class Bloc{
  final _themeControllor = StreamController<bool>();
  changeTheme(bool val){
    _themeControllor.sink.add(val);
  }
  get darkThemeEnabled => _themeControllor.stream;

  dispose(){
    _themeControllor.close();
  }
}

final bloc = Bloc();