import 'package:animations/animations.dart';
import 'package:flut_notes/view/notes_editor.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';

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
          DateTime now = DateTime.now();
          return NotesEditor(
              title:
                  'Notes ${now.year}-${now.month}-${now.day} ${now.hour}-${now.second}');
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
      body: FutureBuilder(
        future: Future.delayed(Duration(seconds: 2)),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return AnimationLimiter(
              child: ListView.builder(
                padding: const EdgeInsets.all(10),
                itemCount: 6,
                itemBuilder: (context, index) {
                  String _notesTitle = 'Title $index';

                  return AnimationConfiguration.staggeredList(
                    position: index,
                    duration: Duration(milliseconds: 200),
                    child: SlideAnimation(
                      verticalOffset: 50,
                      child: FadeInAnimation(
                        child: OpenContainer(
                          closedBuilder: (context, action) {
                            return Card(
                              child: ListTile(
                                title: Text(_notesTitle),
                                subtitle: Text('Item $index'),
                                trailing: Text(
                                  'Edited a month ago',
                                  style: TextStyle(
                                      fontWeight: FontWeight.w100,
                                      fontSize: 12),
                                ),
                              ),
                            );
                          },
                          closedElevation: 0.0,
                          closedColor:
                              Theme.of(context).scaffoldBackgroundColor,
                          openBuilder: (context, action) {
                            return NotesEditor(title: _notesTitle);
                          },
                        ),
                      ),
                    ),
                  );
                },
              ),
            );
          } else {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
    );
  }
}
