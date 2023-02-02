import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flut_notes/firebase_options.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

import 'view/app.dart';
import 'view/auth/sign_in.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    User currentUser = FirebaseAuth.instance.currentUser;
    return MaterialApp(
      title: 'Flutnotes',
      theme: ThemeData(
          primarySwatch: Colors.orange,
          primaryColor: Colors.yellow.shade200,
          fontFamily: GoogleFonts.ubuntu().fontFamily,
          appBarTheme: const AppBarTheme(
            systemOverlayStyle: SystemUiOverlayStyle(
                statusBarColor: Colors.transparent,
                statusBarIconBrightness: Brightness.dark),
          )),
      // home: App(),
      home: currentUser == null ? const SignIn() : App(uid: currentUser.uid),
      // home: AuthFinish(),
    );
  }
}
