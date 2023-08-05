import 'package:cloud_firestore/cloud_firestore.dart';

class UserNotes {
  String title;
  String? docId;
  String? note;

  Timestamp? created;
  Timestamp? modified;

  UserNotes({
    required this.title,
    this.note,
    this.docId,
    this.created,
    this.modified,
  });
}
