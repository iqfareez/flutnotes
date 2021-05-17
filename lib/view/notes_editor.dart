import 'package:flutter/material.dart';

class NotesEditor extends StatefulWidget {
  NotesEditor({@required this.title});
  final String title;
  @override
  _NotesEditorState createState() => _NotesEditorState();
}

class _NotesEditorState extends State<NotesEditor> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController _titleController;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.title);
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: SafeArea(
        child: SingleChildScrollView(
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
                          controller: _titleController,
                          decoration: InputDecoration(border: InputBorder.none),
                          style: TextStyle(
                              fontSize: 21,
                              decoration: TextDecoration.underline,
                              fontWeight: FontWeight.w100,
                              decorationStyle: TextDecorationStyle.dotted),
                        ),
                      ),
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          TextButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: Text('Discard'),
                          ),
                          ElevatedButton(
                            onPressed: () {},
                            child: Text('Save'),
                          ),
                        ],
                      )
                    ],
                  ),
                  TextFormField(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
