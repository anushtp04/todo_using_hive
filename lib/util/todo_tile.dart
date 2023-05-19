import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class ToDoTile extends StatelessWidget {
  String taskName;
  bool taskCompleted;
  Function(bool?) onChanged;
  Function(BuildContext)? deleteFunction;
  Function(BuildContext)? editFunction;

  ToDoTile(
      {required this.taskName,
      required this.taskCompleted,
      required this.onChanged,
      required this.deleteFunction,
      required this.editFunction});

  @override
  Widget build(BuildContext context) {
    return Slidable(
      endActionPane: ActionPane(
        motion: StretchMotion(),
        children: [
          SlidableAction(
            onPressed: deleteFunction,
            icon: Icons.delete,
            backgroundColor: Colors.red,
            borderRadius: BorderRadius.circular(10),
          ),
          SlidableAction(
            onPressed: editFunction,
            icon: Icons.edit_outlined,
            backgroundColor: Colors.green,
            borderRadius: BorderRadius.circular(10),
          ),
        ],
      ),
      child: Container(
        padding: EdgeInsets.all(10),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: Colors.yellow.shade500),
        child: Row(
          children: [
            Checkbox(
                activeColor: Colors.black,
                value: taskCompleted,
                onChanged: onChanged),
            Text(
              taskName,
              style: TextStyle(
                fontSize: 18,
                  fontWeight: FontWeight.w500,
                  decoration: taskCompleted
                      ? TextDecoration.lineThrough
                      : TextDecoration.none),
            ),
          ],
        ),
      ),
    );
  }

}
