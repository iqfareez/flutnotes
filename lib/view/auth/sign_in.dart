import 'package:flut_notes/view/auth/no_auth.dart';
import 'package:flut_notes/view/auth/phone_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class SignIn extends StatefulWidget {
  const SignIn({Key key}) : super(key: key);

  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(children: [
        SvgPicture.asset('assets/blob-scene-haikei.svg', fit: BoxFit.cover),
        SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 38, vertical: 6),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        primary: Colors.orange.shade300),
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (builder) => const PhoneAuth()));
                    },
                    child: const Text('Continue with phone number')),
                ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        primary: Colors.orange.shade300),
                    onPressed: () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (builder) => const NoAuth()));
                    },
                    child: const Text('Continue without account'))
              ],
            ),
          ),
        ),
      ]),
    );
  }
}
