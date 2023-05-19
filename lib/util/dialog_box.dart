import 'package:flutter/material.dart';

class DialogBox extends StatelessWidget {

  final controller;
  VoidCallback onSave;
  VoidCallback onCancel;

  DialogBox({required this.controller, required this.onSave, required this.onCancel});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Colors.yellow.shade300,
      content: Container(
        height: 120,
        child: Column(
          children: [
            TextField(
              controller: controller,
              decoration: InputDecoration(
                hintText: "Add Task Here",
                border: OutlineInputBorder()
              ),
            ),
            SizedBox(height: 5,),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                ElevatedButton(onPressed: onCancel, child: Text("CANCEL"),),
                SizedBox(width: 8,),
                ElevatedButton(onPressed: onSave, child: Text("SAVE"),),
              ],
            )
          ],
        ) ,
      ),
    );
  }
}
