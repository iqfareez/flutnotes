import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flut_notes/utils/user_notes_model.dart';
import 'package:flutter/material.dart';

class NotesEditor extends StatefulWidget {
  NotesEditor({this.userNotes});
  final UserNotes userNotes;

  @override
  _NotesEditorState createState() => _NotesEditorState();
}

class _NotesEditorState extends State<NotesEditor> {
  final _formKey = GlobalKey<FormState>();
  final _userNotesReference = FirebaseFirestore.instance
      .collection('/flutnotes/fFFhZTnPmuNjLUme4O7F/usernotes');
  TextEditingController _titleController;
  TextEditingController _noteController;
  bool _isNew;
  bool _enableEditing = false;
  String _documentId;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.userNotes.title);
    _noteController = TextEditingController(text: widget.userNotes.note);
    _isNew = widget.userNotes.docId == null;
    _documentId = widget.userNotes.docId;
  }

  /// Check whether is there any unsaved changes
  Future<bool> _isSafeToDiscard() async {
    return _noteController.text.isEmpty ||
        await showDialog(
          context: context,
          builder: (builder) {
            return AlertDialog(
              title: Text('title'),
              content: Text('Conetnt'),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context, true);
                  },
                  child: Text('Discard changes'),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.pop(context, false);
                  },
                  child: Text('Continue editing'),
                ),
              ],
            );
          },
        );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _isSafeToDiscard,
      child: Scaffold(
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 16),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Flexible(
                        child: TextFormField(
                          readOnly: !_enableEditing,
                          controller: _titleController,
                          decoration: InputDecoration(
                              border: InputBorder.none, hintText: 'Title'),
                          style: TextStyle(
                              fontSize: 21,
                              decoration: TextDecoration.underline,
                              fontWeight: FontWeight.w100,
                              decorationStyle: TextDecorationStyle.dotted),
                        ),
                      ),
                      Builder(builder: (builder) {
                        if (_enableEditing) {
                          return Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              TextButton(
                                onPressed: () async {
                                  if (await _isSafeToDiscard()) {
                                    Navigator.pop(context);
                                  }
                                },
                                child: Text('Discard'),
                              ),
                              ElevatedButton(
                                onPressed: () async {
                                  if (_isNew) {
                                    _userNotesReference.add({
                                      'title': 'new titile',
                                      'note': 'new note',
                                      'modified': Timestamp.now(),
                                      'created': Timestamp.now(),
                                    }).then((value) {
                                      print('done');
                                      print('${value.id} created');
                                      setState(() {
                                        _documentId = value.id;
                                        _isNew = false;
                                        _enableEditing = false;
                                      });
                                    });
                                  }
                                  _userNotesReference.doc(_documentId).update({
                                    'title': _titleController.text,
                                    'note': _noteController.text,
                                    'modified': Timestamp.now()
                                  }).then((value) {
                                    print('done');
                                    setState(() {
                                      _enableEditing = false;
                                    });
                                  });
                                },
                                child: Text('Save'),
                              ),
                            ],
                          );
                        } else {
                          return TextButton.icon(
                              style:
                                  TextButton.styleFrom(primary: Colors.green),
                              onPressed: () {
                                setState(() {
                                  _enableEditing = true;
                                });
                              },
                              icon: Icon(Icons.lock_outline, size: 20),
                              label: Text('Enable Editing'));
                        }
                      }),
                    ],
                  ),
                  Expanded(
                    child: SingleChildScrollView(
                      child: TextFormField(
                        readOnly: !_enableEditing,
                        controller: _noteController,
                        maxLines: null,
                        decoration: InputDecoration(
                            hintText: 'Your notes here',
                            border: InputBorder.none),
                        textInputAction: TextInputAction.newline,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
