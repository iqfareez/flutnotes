import 'package:firebase_auth/firebase_auth.dart';
import 'package:flut_notes/view/app.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class AuthFinish extends StatelessWidget {
  const AuthFinish({Key key, this.user, this.welcomeText = 'Welcome'})
      : super(key: key);
  final String welcomeText;
  final User user;

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () => Future.value(false),
      child: Scaffold(
        body: Column(
          // crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 4),
              child: Lottie.asset(
                'assets/lf30_editor_r4qlsjkd.json',
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                welcomeText,
                style:
                    const TextStyle(fontSize: 24, fontWeight: FontWeight.w600),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(
                        builder: (builder) => App(
                              uid: user.uid,
                            )),
                    (route) => false);
              },
              child: const Text('Go to My Notes'),
            ),
          ],
        ),
      ),
    );
  }
}
