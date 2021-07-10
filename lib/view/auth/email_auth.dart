/// https://firebase.flutter.dev/docs/auth/phone/
import 'package:animations/animations.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flut_notes/view/auth/auth_finish.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

class EmailAuth extends StatefulWidget {
  const EmailAuth({Key key}) : super(key: key);

  @override
  _EmailAuthState createState() => _EmailAuthState();
}

class _EmailAuthState extends State<EmailAuth> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  int _selectedIndex = 0;
  bool _isRegistration = false;
  List<Widget> _widgets;
  bool _isOperation = false;

  Future<void> emailLogin() async {
    User _user;

    _auth
        .signInWithEmailAndPassword(
            email: _emailController.text, password: _passwordController.text)
        .then((value) => goToFinishAuth('Welcome back!', value.user))
        .catchError((error) {
      print('Got error $error');
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(error.toString())));
    });
  }

  Future<void> registerUser() async {
    User _user;
    try {
      _auth
          .createUserWithEmailAndPassword(
              email: _emailController.text, password: _passwordController.text)
          .then((value) {
        _user = value.user;
      });
    } on FirebaseAuthException catch (e) {
      print('Error regoster user: ${e.message}');
      throw e;
    }
  }

  void goToFinishAuth(String message, User user) {
    Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: (builder) => AuthFinish(
                  welcomeText: message,
                  user: user,
                )));
  }

  Future<void> verifyEmailCode(String emailCode) async {
    // Create a EmailAuthCredential with the code
  }

  @override
  void initState() {
    super.initState();
    _widgets = [
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Padding(
            padding: const EdgeInsets.all(18),
            child: ElevatedButton(
              onPressed: () {
                setState(() {
                  _isRegistration = true;
                  _selectedIndex = 1;
                });
              },
              child: Text('Register'),
            ),
          ),
          Text('OR'),
          Padding(
            padding: const EdgeInsets.all(18),
            child: ElevatedButton(
              onPressed: () {
                setState(() {
                  _isRegistration = false;
                  _selectedIndex = 1;
                });
              },
              child: Text('Sign in'),
            ),
          )
        ],
      ),
      Form(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Enter your email',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
            ),
            SizedBox(height: 10),
            TextFormField(
              validator: (text) =>
                  text.isEmpty ? "Don't leave this field empty" : null,
              controller: _emailController,
              keyboardType: TextInputType.emailAddress,
            ),
            SizedBox(height: 15),
          ],
        ),
      ),
      Form(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              _isRegistration ? 'Create your password' : 'Enter your password',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
            ),
            SizedBox(height: 10),
            TextFormField(
              validator: (text) =>
                  text.isEmpty ? "Don't leave this field empty" : null,
              controller: _passwordController,
              keyboardType: TextInputType.visiblePassword,
              obscureText: true,
            )
          ],
        ),
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Stack(
        children: [
          SvgPicture.asset(
            'assets/blob-scene-haikei-green.svg',
            fit: BoxFit.cover,
          ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                children: [
                  SizedBox(height: 20),
                  Card(
                    margin: const EdgeInsets.all(0.0),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 18, vertical: 10),
                      child: PageTransitionSwitcher(
                        transitionBuilder: (Widget child,
                            Animation<double> primaryAnimation,
                            Animation<double> secondaryAnimation) {
                          return SharedAxisTransition(
                            fillColor: Theme.of(context).cardColor,
                            animation: primaryAnimation,
                            secondaryAnimation: secondaryAnimation,
                            transitionType: SharedAxisTransitionType.horizontal,
                            child: child,
                          );
                        },
                        child: Container(
                          key: ValueKey<int>(_selectedIndex),
                          child: _widgets[_selectedIndex],
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 10),
                  Builder(builder: (context) {
                    if (_selectedIndex == 0) {
                      return SizedBox.shrink();
                    } else {
                      return ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 30)),
                        onPressed: !_isOperation
                            ? _selectedIndex == 1
                                ? () {
                                    setState(() {
                                      _selectedIndex = 2;
                                    });
                                  }
                                : () async {
                                    setState(() {
                                      _isOperation = true;
                                    });

                                    FocusScope.of(context)
                                        .unfocus(); //Hide the keyboard
                                    _isRegistration
                                        ? await registerUser()
                                        : await emailLogin();
                                    setState(() {
                                      _isOperation = false;
                                    });
                                  }
                            : null,
                        child: _isOperation
                            ? SizedBox(
                                height: 20,
                                width: 20,
                                child: CircularProgressIndicator())
                            : Text('Continue'),
                      );
                    }
                  }),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
