import 'package:flutter/material.dart';

class App extends StatefulWidget {
  App({this.title});
  final String title;
  @override
  _AppState createState() => _AppState();
}

class _AppState extends State<App> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.title)),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          print('pressed');
        },
      ),
    );
  }
}
