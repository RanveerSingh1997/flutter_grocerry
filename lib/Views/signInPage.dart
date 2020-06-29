import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_grocerry_app/Widgets/customButton.dart';
import 'package:flutter_grocerry_app/Widgets/inputFields.dart';
import 'package:flutter_grocerry_app/Widgets/style.dart';
import 'home_page.dart';

class SignInPage extends StatefulWidget {
  static final String routName = '/SignInPage';
  final String pageTitle;

  SignInPage({Key key, this.pageTitle}) : super(key: key);

  @override
  _SignInPageState createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  String phoneNo;
  String smsOTP;
  String verificationId;
  String errorMessage = '';
  FirebaseAuth _auth = FirebaseAuth.instance;

  Future<void> verifyPhone() async {
    final PhoneCodeSent smsOTPSent = (String verId, [int forceCodeResend]) {
      this.verificationId = verId;
      smsOTPDialog(context).then((value) {
        print(value);
      });
    };
    try {
      await _auth.verifyPhoneNumber(
          phoneNumber: this.phoneNo,
          // PHONE NUMBER TO SEND OTP
          codeAutoRetrievalTimeout: (String verId) {
            this.verificationId = verId;
          },
          codeSent: smsOTPSent,
          // WHEN CODE SENT THEN WE OPEN DIALOG TO ENTER OTP.
          timeout: const Duration(seconds: 60),
          verificationCompleted: (AuthCredential phoneAuthCredential) {
            _auth
                .signInWithCredential(phoneAuthCredential)
                .then((AuthResult authResult) {
              Navigator.of(context).pop();
              Navigator.of(context).pushReplacementNamed(HomePage.routName);
            });
          },
          verificationFailed: (AuthException exception) {
            print('${exception.message}');
          });
    } catch (e) {
      handleError(e);
    }
  }

  Future<bool> smsOTPDialog(BuildContext context) {
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return new AlertDialog(
          title: Text('Enter SMS Code'),
          content: Container(
            height: 85,
            child: Column(children: [
              TextField(
                onChanged: (value) {
                  this.smsOTP = value;
                },
                decoration: InputDecoration(),
                keyboardType: TextInputType.number,
              ),
              (errorMessage != ''
                  ? Text(
                errorMessage,
                style: TextStyle(color: Colors.red),
              )
                  : Container())
            ]),
          ),
          contentPadding: EdgeInsets.all(10),
          actions: <Widget>[
            OutlineButton(
              child: Text('cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            FlatButton(
              child: Text('Done'),
              onPressed: () {
                _auth.currentUser().then((user) {
                  if (user != null) {
                    Navigator.of(context).pop();
                    Navigator.of(context)
                        .pushReplacementNamed(HomePage.routName);
                  } else {
                    print('SignIn');
                    signIn();
                  }
                });
              },
            )
          ],
        );
      },
    );
  }

  signIn() async {
    try {
      final AuthCredential credential = PhoneAuthProvider.getCredential(
        verificationId: verificationId,
        smsCode: smsOTP,
      );
      final FirebaseUser user =
      (await _auth.signInWithCredential(credential)) as FirebaseUser;
      final FirebaseUser currentUser = await _auth.currentUser();
      assert(user.uid == currentUser.uid);
      Navigator.of(context).pop();
      Navigator.of(context).pushReplacementNamed(HomePage.routName);
    } catch (e) {
      handleError(e);
    }
  }

  handleError(PlatformException error) {
    print(error);
    switch (error.code) {
      case 'ERROR_INVALID_VERIFICATION_CODE':
        FocusScope.of(context).requestFocus(new FocusNode());
        setState(() {
          errorMessage = 'Invalid Code';
        });
        Navigator.of(context).pop();
        smsOTPDialog(context).then((value) {
          print(value);
          print('sign in');
        });
        break;
      default:
        setState(() {
          errorMessage = error.message;
        });

        break;
    }
  }

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          elevation: 0,
          backgroundColor:Colors.grey[100],
          title: Text('Sign In',
              style: TextStyle(
                  color: Colors.grey, fontFamily: 'Poppins', fontSize: 15)),
        ),
        body:Container(
          decoration:authPlateDecoration,
          child:Column(
            crossAxisAlignment:CrossAxisAlignment.center,
            mainAxisAlignment:MainAxisAlignment.center,
            children: <Widget>[
              Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Text('Welcome Back!', style:h3.copyWith(fontSize:30)),
                    Text('Let\'s authenticate', style: taglineText.copyWith(fontSize:24)),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: fryoTextInput('Phone Number', prefix: Text('+91'),
                        onChanged: (value) {
                          phoneNo = '+91' + value;
                        },
                        keyboardType: TextInputType.numberWithOptions(
                          signed: true, decimal: false,),
                      ),
                    ),
                    SizedBox(height:30,),
                    Container(
                      width:100,
                      child: CustomFlatButton(
                        onPress: () {
                          Navigator.of(context).pushReplacementNamed(HomePage.routName);
                        },
                        text:'SUBMIT',
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
        ));
  }
}
