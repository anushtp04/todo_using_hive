import 'package:flutter/material.dart';

class SearchBox extends StatelessWidget {


   SearchBox({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      padding: EdgeInsets.symmetric(horizontal: 15),
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            offset: Offset(0, 0),
            blurRadius: 1,
            spreadRadius: 1,
            color: Colors.grey.shade500,
            blurStyle: BlurStyle.outer
          )
        ]
      ),
      child: TextField(
        decoration: InputDecoration(
            border: InputBorder.none,
            prefixIcon: Icon(Icons.search),
            prefixIconConstraints: BoxConstraints(maxHeight: 25,maxWidth: 25),
            hintText: "Search"

        ),
      ),
    );
  }
}