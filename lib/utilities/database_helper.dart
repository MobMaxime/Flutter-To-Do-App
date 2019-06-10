import 'package:sqflite/sqflite.dart';
import 'dart:async';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:to_do/models/task.dart';

class DatabaseHelper {

  static DatabaseHelper _databaseHelper; //Singleton DatabaseHelper
  static Database _database; //Singleton Database

  String taskTable = "task_table";
  String colId = "id";
  String colTask = "task";
  String colDate = "date";
  String colTime = "time";
  String colStatus = "status";

  DatabaseHelper._createInstance();

  factory DatabaseHelper() {
    if (_databaseHelper == null) {
      _databaseHelper = DatabaseHelper._createInstance();
    }
    return _databaseHelper;
  }

  Future<Database> get database async {
    if (_database == null) {
      _database = await initializeDatabase();
    }
    return _database;
  }

  Future<Database> initializeDatabase() async {
    //Get the directory path for both Android and iOS to store Database.
    Directory directory = await getApplicationDocumentsDirectory();
    String path = directory.path + "task.db";

    //Open/Create the database at the given path
    var taskDatabase =
        await openDatabase(path, version: 1, onCreate: _createDb);

    return taskDatabase;
  }

  void _createDb(Database db, int newVersion) async {
    await db.execute(
        'CREATE TABLE $taskTable ($colId INTEGER PRIMARY KEY AUTOINCREMENT, $colTask TEXT, $colDate TEXT, $colTime TEXT, $colStatus TEXT)');
  }

  //Fetch Operation: Get all Task objects from database
  Future<List<Map<String, dynamic>>> getTaskMapList() async {
    Database db = await this.database;
    //var result = db.rawQuery('SELECT * FROM $taskTable order by $colDate, $colTime ASC');
    var result = db.query(taskTable, orderBy: '$colStatus, $colDate, $colTime');
    return result;
  }

  Future<List<Map<String, dynamic>>> getInCompleteTaskMapList() async {
    Database db = await this.database;
    var result = db.rawQuery('SELECT * FROM $taskTable where $colStatus = "" order by $colDate, $colTime ASC');
    //var result = db.query(taskTable, orderBy: '$colStatus, $colDate, $colTime');
    return result;
  }

  Future<List<Map<String, dynamic>>> getCompleteTaskMapList() async {
    Database db = await this.database;
    var result = db.rawQuery('SELECT * FROM $taskTable where $colStatus = "Task Completed" order by $colDate, $colTime ASC');
    //var result = db.query(taskTable, orderBy: '$colStatus, $colDate, $colTime');
    return result;
  }



  //Insert Operation: Insert a Task object to database
  Future<int> insertTask(Task task) async {
    Database db = await this.database;
    var result = await db.insert(taskTable, task.toMap());
    return result;
  }

  //Update Operation: Update a Task object and save it to database
  Future<int> updateTask(Task task) async {
    var db = await this.database;
    var result = await db.update(taskTable, task.toMap(), where: '$colId = ?', whereArgs: [task.id] );
    return result;
  }

  //Delete Operation: Delete a Task object from database
  Future<int> deleteTask(int id) async{
    var db = await this.database;
    int result = await db.rawDelete('DELETE FROM $taskTable WHERE $colId=$id');
    return result;
  }

  //Get no. of Task objects in database
  Future<int> getCount() async{
    Database db = await this.database;
    List<Map<String, dynamic>> x = await db.rawQuery('SELECT COUNT (*) FROM $taskTable');
    int result = Sqflite.firstIntValue(x);
    return result;
  }

  Future<List<Task>> getTaskList() async{
    var taskMapList = await getTaskMapList(); //Get Map List from database
    int count = taskMapList.length;

    List<Task> taskList = List<Task>();
    //For loop to create Task List from a Map List
    for (int i=0; i<count; i++){
      taskList.add(Task.fromMapObject(taskMapList[i]));
    }
    return taskList;
  }

  Future<List<Task>> getInCompleteTaskList() async{
    var taskMapList = await getInCompleteTaskMapList(); //Get Map List from database
    int count = taskMapList.length;

    List<Task> taskList = List<Task>();
    //For loop to create Task List from a Map List
    for (int i=0; i<count; i++){
      taskList.add(Task.fromMapObject(taskMapList[i]));
    }
    return taskList;
  }

  Future<List<Task>> getCompleteTaskList() async{
    var taskMapList = await getCompleteTaskMapList(); //Get Map List from database
    int count = taskMapList.length;

    List<Task> taskList = List<Task>();
    //For loop to create Task List from a Map List
    for (int i=0; i<count; i++){
      taskList.add(Task.fromMapObject(taskMapList[i]));
    }
    return taskList;
  }
}
