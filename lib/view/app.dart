import 'package:animations/animations.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flut_notes/utils/user_notes_model.dart';
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
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  Stream userDocumentStream;
  Stream userNotesStream;
  @override
  void initState() {
    super.initState();
    userDocumentStream =
        firestore.doc('/flutnotes/fFFhZTnPmuNjLUme4O7F').snapshots();
    userNotesStream = firestore
        .collection('/flutnotes/fFFhZTnPmuNjLUme4O7F/usernotes')
        .snapshots();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.title)),
      floatingActionButton: OpenContainer(
        openBuilder: (context, action) {
          DateTime now = DateTime.now();
          return NotesEditor(
              userNotes: UserNotes(
                  title:
                      'Notes ${now.year}-${now.month}-${now.day} ${now.hour}${now.second}'));
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
      body: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
        stream: userNotesStream,
        builder: (context,
            AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
          // https://firebase.flutter.dev/docs/firestore/usage/
          // cer try guna stream lak
          // https://console.firebase.google.com/u/0/project/mini-project-56b22/firestore/data/~2Fflutnotes
          if (snapshot.hasError) {
            print(snapshot.error);
            return Center(
              child: Icon(Icons.error_outline),
            );
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }

          return AnimationLimiter(
            child: ListView.builder(
              padding: const EdgeInsets.all(10),
              itemCount: snapshot.data.size,
              itemBuilder: (context, index) {
                UserNotes _notes = UserNotes(
                    docId: snapshot.data.docs[index].id,
                    title: snapshot.data.docs[index].data()["title"],
                    note: snapshot.data.docs[index].data()["note"],
                    created: snapshot.data.docs[index].data()["created"],
                    modified: snapshot.data.docs[index].data()["modified"]);

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
                              title: Text(_notes.title),
                              subtitle: Text(_notes.note, maxLines: 1),
                              trailing: Text(
                                _notes.created.toDate().toString(),
                                style: TextStyle(
                                    fontWeight: FontWeight.w100, fontSize: 12),
                              ),
                            ),
                          );
                        },
                        closedElevation: 0.0,
                        closedColor: Theme.of(context).scaffoldBackgroundColor,
                        openBuilder: (context, action) {
                          return NotesEditor(
                            userNotes: _notes,
                          );
                        },
                      ),
                    ),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
