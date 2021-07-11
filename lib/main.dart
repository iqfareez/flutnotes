import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flut_notes/view/app.dart';
import 'package:flut_notes/view/auth/auth_finish.dart';
import 'package:flut_notes/view/auth/sign_in.dart';
import 'package:flut_notes/view/notes_editor.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.

  @override
  Widget build(BuildContext context) {
    User _currentUser = FirebaseAuth.instance.currentUser;
    return MaterialApp(
      title: 'Flutnotes',
      theme: ThemeData(
        primarySwatch: Colors.orange,
        primaryColor: Colors.yellow.shade200,
        fontFamily: GoogleFonts.ubuntu().fontFamily,
      ),
      // home: App(),
      home: _currentUser == null ? SignIn() : App(uid: _currentUser.uid),
      // home: AuthFinish(),
    );
  }
}
