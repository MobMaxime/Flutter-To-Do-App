class Task {
  int _id;
  String _task, _date, _time;
 // bool _addToList;

  Task(this._task, this._date, this._time, /*this._addToList*/);
  Task.withId(this._id, this._task, this._date, this._time, /*this._addToList*/);

  int get id => _id;
  String get task => _task;
  String get date => _date;
  String get time => _time;
  //bool get added => _addToList;

  set task(String newTask){
    if(newTask.length <= 255){
      this._task = newTask;
    }
  }

  set date(String newDate) => this._date=newDate;
  set time(String newTime) => this._time=newTime;

  //set added(bool newAddToList) => this._addToList=newAddToList;

  //Convert Task object into MAP object
  Map<String, dynamic> toMap(){
    var map = Map<String, dynamic>();
    if(id != null)
      map['id'] = _id;
    map['task'] = _task;
    map['date'] = _date;
    map['time'] = _time;
    //map['added'] = _addToList;

    return map;
  }

  //Extract Task object from MAP object
  Task.fromMapObject(Map<String, dynamic> map){
    this._id = map['id'];
    this._task = map['task'];
    this._date = map['date'];
    this._time = map['time'];
    //this._addToList = map['added'];

  }

}
