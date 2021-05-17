import 'package:animations/animations.dart';
import 'package:flut_notes/view/notes_editor.dart';
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
      floatingActionButton: OpenContainer(
        openBuilder: (context, action) {
          return NotesEditor();
        },
        closedShape: CircleBorder(),
        // closedElevation: 5.0,
        closedBuilder: (context, action) {
          return FloatingActionButton(
            child: Icon(Icons.add),
            onPressed: () {
              print('pressed');
              action.call();
            },
          );
        },
      ),
      body: ListView.builder(
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.all(12),
            child: ListTile(
              subtitle: Text('Item $index'),
            ),
          );
        },
      ),
    );
  }
}
