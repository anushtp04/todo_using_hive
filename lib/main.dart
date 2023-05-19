import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/adapters.dart';

import 'pages/homePage.dart';

void main() async{
  await Hive.initFlutter();
  await Hive.openBox("myBox");
  runApp( MyApp());
}

class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home:  HomePage(),
      theme: ThemeData(primarySwatch: Colors.yellow),
    );
  }
}

