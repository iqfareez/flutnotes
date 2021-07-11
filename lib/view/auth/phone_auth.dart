/// https://firebase.flutter.dev/docs/auth/phone/
import 'package:animations/animations.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flut_notes/view/auth/auth_finish.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

class PhoneAuth extends StatefulWidget {
  const PhoneAuth({Key key}) : super(key: key);

  @override
  _PhoneAuthState createState() => _PhoneAuthState();
}

class _PhoneAuthState extends State<PhoneAuth> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _inputController = TextEditingController();
  final TextEditingController _smsCodeController = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  int _selectedIndex = 0;
  String _verificationId;
  List<Widget> _widgets;
  bool _isOperation = false;
  bool _isVerifyingSms = false;

  Future<void> phoneLogin(String phoneNumber) async {
    setState(() {
      _isOperation = true;
    });
    await _auth.verifyPhoneNumber(
        phoneNumber: phoneNumber,
        verificationCompleted: (credential) async {
          print('verification completed is $credential');
          // Sign the user in (or link) with the auto-generated credential
          UserCredential _userCredential =
              await _auth.signInWithCredential(credential);
          User _user = _userCredential.user;
          goToFinishAuth('Welcome back!', _user);
        },
        verificationFailed: (FirebaseAuthException e) {
          print('error ${e.message}');
        },
        codeSent: (verificationId, resendToken) async {
          print('code sent');
          // Update the UI - wait for the user to enter the SMS code
          setState(() {
            _verificationId = verificationId;
            _selectedIndex = 1;
          });
        },
        codeAutoRetrievalTimeout: (verificationId) {
          print('autoRetrievalTimeout $verificationId');
        });
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

  Future<void> verifySmsCode(String smsCode) async {
    // Create a PhoneAuthCredential with the code
    setState(() {
      _isVerifyingSms = true;
    });
    print('smsCode is $smsCode');
    try {
      PhoneAuthCredential credential = PhoneAuthProvider.credential(
          verificationId: _verificationId, smsCode: smsCode);

      // Sign the user in (or link) with the credential
      UserCredential _userCredential =
          await _auth.signInWithCredential(credential);
      User _user = _userCredential.user;
      print('Code sent done. Signed in with ${_user.toString()}');

      goToFinishAuth('Welcome Abroad!', _user);
    } on FirebaseAuthException catch (e) {
      setState(() {
        _isVerifyingSms = false;
      });
      print('got error auth $e');
      _smsCodeController.clear();
      if (e.code == "invalid-verification-code") {
        showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: Text('Invalid SMS code'),
                content: Text('Please reenter the SMS code'),
                actions: [
                  TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: Text('OK'))
                ],
              );
            });
      }
    }
  }

  @override
  void initState() {
    super.initState();
    _widgets = [
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Enter your phone number',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
          ),
          SizedBox(height: 10),
          InternationalPhoneNumberInput(
            textFieldController: _inputController,
            selectorConfig: SelectorConfig(
              selectorType: PhoneInputSelectorType.DIALOG,
              useEmoji: true,
            ),
            inputDecoration: InputDecoration(isDense: true),
            spaceBetweenSelectorAndTextField: 3,
            onInputChanged: (number) {},
            onSaved: (number) {
              print('saved ${number.phoneNumber}');
              phoneLogin(number.phoneNumber);
            },
          ),
        ],
      ),
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'An OTP was sent to the phone',
            style: TextStyle(
                // fontSize: 18,
                ),
          ),
          SizedBox(height: 2),
          Text(
            'Enter the code below',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
          ),
          SizedBox(height: 10),
          PinCodeTextField(
            keyboardType: TextInputType.number,
            controller: _smsCodeController,
            appContext: context,
            length: 6,
            onChanged: (code) {},
            onCompleted: (code) {
              print('complited $code');
              verifySmsCode(code);
            },
          ),
        ],
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
            'assets/blob-scene-haikei (1).svg',
            fit: BoxFit.cover,
          ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Form(
                key: _formKey,
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
                              transitionType:
                                  SharedAxisTransitionType.horizontal,
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
                      if (_isVerifyingSms) {
                        return LinearProgressIndicator();
                      }
                      if (_selectedIndex == 1) {
                        return SizedBox.shrink();
                      } else {
                        return ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 30)),
                          onPressed: !_isOperation
                              ? () {
                                  _formKey.currentState.save();
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
          ),
        ],
      ),
    );
  }
}
