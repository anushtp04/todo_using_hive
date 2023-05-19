import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:todo_using_hive/data/database.dart';
import 'package:todo_using_hive/util/dialog_box.dart';
import 'package:todo_using_hive/util/todo_tile.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  @override
  void initState() {
    if (_myBox.get("TODOLIST") == null) {
      db.createInitialData();
    }
    else {
      db.loadDatabase();
    }

    super.initState();
  }

  final _myBox = Hive.box("myBox");

  ToDoDatabase db = ToDoDatabase();

  final _controller = TextEditingController();
  var _newController = TextEditingController();

  void checkBoxChanged(bool? value, int index) {
    setState(() {
      db.toDoList[index][1] = !db.toDoList[index][1];
    });
    db.updateDatabase();
  }

  void createNewTask() {
    showDialog(
      context: context,
      builder: (context) {
        return DialogBox(
          controller: _controller,
          onSave: saveNewTask,
          onCancel: () {
            Navigator.pop(context);
          },
        );
      },
    );
  }

  void saveNewTask() {
    setState(() {
      db.toDoList.add([_controller.text, false]);
      _controller.clear();
    });
    Navigator.pop(context);
    db.updateDatabase();
  }

  void deleteTask(int index) {
    setState(() {
      db.toDoList.removeAt(index);
    });
    db.updateDatabase();
  }

  void editTask(int index) {
    showDialog(context: context, builder: (context) {
      _newController.text= db.toDoList[index][0];
      return DialogBox(controller: _newController,
          onSave: () {
            setState(() {
              db.toDoList[index][0] = _newController.text;
              _newController.clear();
            });
            Navigator.pop(context);
            db.updateDatabase();
          },
          onCancel: () {
        Navigator.pop(context);

          },);
    },);
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.yellow.shade200,
        appBar: AppBar(
          elevation: 0,
          title: Text("TO DO",style: TextStyle(fontSize: 22,fontWeight: FontWeight.bold),),
          centerTitle: true,
        ),
        floatingActionButton: FloatingActionButton(
            onPressed: () => createNewTask(), child: Icon(Icons.add)),
        body: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          child: ListView.separated(
            itemCount: db.toDoList.length,
            itemBuilder: (context, index) {
              return ToDoTile(
                taskName: db.toDoList[index][0],
                taskCompleted: db.toDoList[index][1],
                onChanged: (value) => checkBoxChanged(value, index),
                deleteFunction: (context) => deleteTask(index),
                editFunction: (context) => editTask(index),
              );
            },
            separatorBuilder: (BuildContext context, int index) {
              return Divider(
                height: 20,
              );
            },
          ),
        ));
  }


}
