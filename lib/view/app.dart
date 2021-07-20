import 'package:animations/animations.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flut_notes/utils/user_notes_model.dart';
import 'package:flut_notes/view/auth/sign_in.dart';
import 'package:flut_notes/view/notes_editor.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:lottie/lottie.dart';
import 'package:timeago/timeago.dart' as timeago;

class App extends StatefulWidget {
  const App({Key key, this.uid}) : super(key: key);
  final String uid;
  @override
  _AppState createState() => _AppState();
}

class _AppState extends State<App> {
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  DocumentReference _userDocument;
  CollectionReference _userNotes;
  // Stream _userDocumentStream;
  Stream _userNotesStream;
  @override
  void initState() {
    super.initState();
    _userDocument = firestore.doc('/flutnotes/${widget.uid}');
    // _userDocumentStream = _userDocument.snapshots();
    _userNotes = _userDocument.collection('usernotes');
    _userNotesStream = _userDocument.collection('usernotes').snapshots();
  }

  Widget deleteIcon = const Padding(
      padding: EdgeInsets.all(12.0),
      child: Icon(
        Icons.delete_outlined,
        size: 30,
        color: Colors.white,
      ));

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Notes'),
        actions: [
          IconButton(
              onPressed: () async {
                await FirebaseAuth.instance.signOut();
                Navigator.pushReplacement(context,
                    MaterialPageRoute(builder: (builder) => const SignIn()));
              },
              icon: const Icon(Icons.logout))
        ],
      ),
      floatingActionButton: OpenContainer(
        openBuilder: (context, action) {
          DateTime now = DateTime.now();
          return NotesEditor(
              userNotes: UserNotes(
                  title:
                      'Notes ${now.year}-${now.month}-${now.day} ${now.hour}${now.second}'));
        },
        closedShape: const CircleBorder(),
        // closedElevation: 5.0,
        closedBuilder: (context, action) {
          return FloatingActionButton(
            child: const Icon(Icons.add),
            onPressed: () => action.call(),
          );
        },
      ),
      body: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
        stream: _userNotesStream,
        builder: (context,
            AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
          // https://firebase.flutter.dev/docs/firestore/usage/
          // cer try guna stream lak
          // https://console.firebase.google.com/u/0/project/mini-project-56b22/firestore/data/~2Fflutnotes
          if (snapshot.hasError) {
            return const Center(
              child: Icon(Icons.error_outline),
            );
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (snapshot.data.size == 0) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(18.0),
                child: Column(
                  children: [
                    const SizedBox(height: 20),
                    // ignore: sized_box_for_whitespace
                    Container(
                        width: 140,
                        child: Lottie.asset(
                          'assets/629-empty-box.json',
                        )),
                    Text(
                      'Krik krikk. Start adding note by tapping + on lower left corner',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.grey.shade800,
                      ),
                    )
                  ],
                ),
              ),
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

                return Dismissible(
                  key: Key(_notes.docId),
                  onDismissed: (direction) async {
                    await _userNotes.doc(_notes.docId).delete();
                    ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('${_notes.title} deleted')));
                  },
                  background: Container(
                    margin: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                        color: Colors.red,
                        borderRadius: BorderRadius.circular(4.0)),
                    child: DefaultTextStyle(
                      style: const TextStyle(color: Colors.redAccent),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [deleteIcon, deleteIcon],
                      ),
                    ),
                  ),
                  child: Container(
                    margin: const EdgeInsets.symmetric(vertical: 4.0),
                    child: AnimationConfiguration.staggeredList(
                      position: index,
                      duration: const Duration(milliseconds: 200),
                      child: SlideAnimation(
                        verticalOffset: 50,
                        child: FadeInAnimation(
                          child: OpenContainer(
                            closedBuilder: (context, action) {
                              return Card(
                                margin: const EdgeInsets.all(0.0),
                                child: ListTile(
                                  title: Text(_notes.title),
                                  subtitle: _notes.note.isNotEmpty
                                      ? Text(
                                          _notes.note,
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                        )
                                      : null,
                                  trailing: Text(
                                    timeago.format(_notes.modified.toDate()),
                                    // _notes.created.toDate().toString(),
                                    style: const TextStyle(
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
                              return NotesEditor(
                                userNotes: _notes,
                              );
                            },
                          ),
                        ),
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
