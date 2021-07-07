import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';

class UserNotes {
  String docId;
  String title;
  String note;

  Timestamp created;
  Timestamp modified;

  UserNotes(
      {@required this.title,
      this.note,
      this.docId,
      this.created,
      this.modified});
}
