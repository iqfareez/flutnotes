import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'auth_finish.dart';

class NoAuth extends StatefulWidget {
  const NoAuth({Key key}) : super(key: key);

  @override
  State<NoAuth> createState() => _NoAuthState();
}

class _NoAuthState extends State<NoAuth> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  bool _isOperation = false;

  void goToFinishAuth(String message, User user) {
    Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: (builder) => AuthFinish(
                  welcomeText: message,
                  user: user,
                )));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        alignment: Alignment.center,
        children: [
          SvgPicture.asset(
            'assets/blob-scene-haikei-green.svg',
            fit: BoxFit.cover,
          ),
          Padding(
            padding: const EdgeInsets.all(18.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Card(
                  child: Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text(
                        'Your notes can\'t be restored if the app is unistalled or changed phone.'),
                  ),
                ),
                const SizedBox(height: 10),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(horizontal: 30)),
                  onPressed: _isOperation
                      ? null
                      : () {
                          setState(() {
                            _isOperation = true;
                          });
                          _auth.signInAnonymously().then((value) {
                            goToFinishAuth('Welcome aboard!', value.user);
                            setState(() {
                              _isOperation = false;
                            });
                          });
                        },
                  child: _isOperation
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator())
                      : const Text('Continue'),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
