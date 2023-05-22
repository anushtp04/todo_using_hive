import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:todo_using_hive/util/searchBox.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Map<String, dynamic>> tasks = [];
  List<Map<String, dynamic>> filteredTasks = [];

  final tbox = Hive.box("myBox");

  @override
  void initState() {
    super.initState();
    loadTask();
  }

  TextEditingController searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade300,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.grey.shade300,
        leading: IconButton(
            onPressed: () {}, icon: Icon(Icons.menu, color: Colors.black)),
        actions: [
          IconButton(
              onPressed: () => showForm(context, null),
              icon: Icon(
                Icons.add,
                color: Colors.black,
                size: 30,
              )),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Welcome Anush!",
                  style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  height: 30,
                ),
                SearchBox(searchController: searchController, searchOnChanged: (String value) {
                  setState(() {
                    filteredTasks = tasks.where((task) => task["task"].toString().toLowerCase().contains(value.toLowerCase())).toList();
                  });
                },),
                SizedBox(
                  height: 20,
                ),
                Text(
                  "My Tasks",
                  style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey.shade700),
                )
              ],
            ),
          ),
          Expanded(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: tasks.isEmpty
                  ? Center(
                child: Text(
                  "No Data",
                  style: TextStyle(
                      fontSize: 26, fontWeight: FontWeight.bold),
                ),
              )
                  : ListView.separated(
                itemBuilder: (context, index) =>
                    ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: Container(
                        color: Colors.white,
                        child: Slidable(
                          startActionPane:
                          ActionPane(motion: DrawerMotion(), children: [
                            SlidableAction(
                              onPressed: (context) =>
                                  showForm(context, filteredTasks[index]["key"]),
                              backgroundColor: Colors.green,
                              foregroundColor: Colors.black,
                              icon: Icons.edit,
                            ),
                          ]),
                          endActionPane:
                          ActionPane(motion: DrawerMotion(), children: [
                            SlidableAction(
                              onPressed: (context) =>
                                  deleteTask(filteredTasks[index]["key"]),
                              backgroundColor: Colors.red,
                              foregroundColor: Colors.black,
                              icon: Icons.delete,
                            ),
                          ]),
                          child: ListTile(
                            contentPadding: EdgeInsets.only(
                                left: 15, right: 15, top: 5, bottom: 5),
                            title: Text(
                              filteredTasks[index]["task"],
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 17,
                                  fontWeight: FontWeight.bold,
                                  decorationThickness: 2,
                                  decoration: filteredTasks[index]["isChecked"] ? TextDecoration.lineThrough : TextDecoration.none
                              ),
                            ),
                            leading: Checkbox(
                              activeColor: Colors.black,
                              value: filteredTasks[index]["isChecked"],
                              onChanged: (value) => checkBoxChanged(value!, index),
                            ),
                          ),
                        ),
                      ),
                    ),
                separatorBuilder: (context, index) =>
                    Divider(
                      height: 15,
                    ),
                itemCount: filteredTasks.length,
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.pink,
        onPressed: () {
          showForm(context, null);
        },
        child: Icon(Icons.add),
      ),
    );
  }

  TextEditingController task_controller = TextEditingController();

  void showForm(BuildContext context, int? id) async {
    if (id != null) {
      final existingTask = tasks.firstWhere((data) => data["key"] == id);
      task_controller.text = existingTask["task"];
    }

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Colors.grey.shade300,
          title: Text("Tasks"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: task_controller,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.white,
                  hintText: "Task details",
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                      task_controller.text = "";
                    },
                    child: Text("CANCEL"),
                  ),
                  SizedBox(
                    width: 5,
                  ),
                  ElevatedButton(
                    onPressed: () {
                      if (id == null) {
                        createTask({"task": task_controller.text});
                      }
                      if (id != null) {
                        updateTask(id, {"task": task_controller.text});
                      }

                      task_controller.text = "";
                      searchController.clear();
                      Navigator.pop(context);
                    },
                    child: Text(id == null ? "CREATE" : "UPDATE"),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> createTask(Map<String, dynamic> myTask) async {
    await tbox.add(myTask);
    loadTask();
  }

  void loadTask() {
    final data = tbox.keys.map((id) {
      final values = tbox.get(id);
      return {"key": id, "task": values["task"], "isChecked" : values["isChecked"] ?? false,};
    }).toList();
    setState(() {
      tasks = data.reversed.toList();
      filteredTasks = tasks;
    });
  }

  Future<void> deleteTask(int myTask) async {
    await tbox.delete(myTask);
    loadTask();
  }

  Future<void> updateTask(int id, Map<String, dynamic> myTask) async {
    await tbox.put(id, myTask);
    loadTask();
  }

  checkBoxChanged(bool? value, int index) {
    final taskId = tasks[index]["key"];
    tbox.put(taskId, {"task": tasks[index]["task"], "isChecked": value});
    setState(() {
      tasks[index]["isChecked"] = value;
    });
  }


}
