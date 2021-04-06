import 'package:flut_notes/view/app.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutnotes',
      theme: ThemeData(
        primarySwatch: Colors.yellow,
      ),
      home: App(title: 'Flutnotes'),
    );
  }
}
