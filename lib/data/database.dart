import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';

class ToDoDatabase {

  List toDoList = [];

  final _myBox = Hive.box("myBox");

  void createInitialData(){
    toDoList = [
      ["Wake up at 7am", false],
      ["Go to Gym", false],
    ];
  }

  void loadDatabase()async{
      toDoList = _myBox.get("TODOLIST");
  }

  void updateDatabase() async{
     await _myBox.put("TODOLIST", toDoList);
  }


}