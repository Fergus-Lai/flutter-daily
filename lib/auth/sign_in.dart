import 'package:android_daily/style.dart';
import 'package:android_daily/auth/sign_up.dart';

import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';

class SignIn extends StatefulWidget {
  const SignIn({Key? key}) : super(key: key);

  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignIn> {
  // Text Editing Controller For Text Field
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  // Variable To Show Error
  String emailHelper = '';
  bool emailError = false;

  String passwordHelper = '';
  bool passwordError = false;

  // On Press Handler For Sign Up Clickable Text
  void onSignUpPressHandler() {
    Navigator.push(context, MaterialPageRoute(builder: (context) => SignUp()));
  }

  // On Press Handler For Sign In Button
  Future<void> onSignInPressHandler() async {
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: emailController.text, password: passwordController.text);
    } on FirebaseAuthException catch (e) {
      // User Not Found
      if (e.code == 'user-not-found') {
        setState(() {
          emailHelper = 'User Not Found';
          emailError = true;
          passwordHelper = '';
          passwordError = false;
        });
        // Wrong Password
      } else if (e.code == 'wrong-password') {
        setState(() {
          emailHelper = '';
          emailError = false;
          passwordHelper = 'Incorrect Password';
          passwordError = true;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: backgroundColor,
        body: Padding(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              children: [
                // Place Holder
                Flexible(flex: 1, child: Container()),
                // Email Text Field
                TextField(
                    controller: emailController,
                    keyboardType: TextInputType.emailAddress,
                    style: activeTextStyle,
                    decoration: InputDecoration(
                        enabledBorder: UnderlineInputBorder(
                            borderSide:
                                BorderSide(color: helperColor(emailError))),
                        focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: activeTextColor)),
                        focusColor: activeTextColor,
                        hintText: "Email",
                        hintStyle: inactiveTextStyle,
                        helperText: emailHelper,
                        helperStyle: TextStyle(
                            color: helperColor(emailError),
                            fontSize: helperSize),
                        icon: Icon(
                          Icons.mail,
                          color: activeTextColor,
                        ))),
                // Password Text Field
                TextField(
                  controller: passwordController,
                  obscureText: true,
                  keyboardType: TextInputType.visiblePassword,
                  style: activeTextStyle,
                  decoration: InputDecoration(
                      enabledBorder: UnderlineInputBorder(
                          borderSide:
                              BorderSide(color: helperColor(passwordError))),
                      focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: activeTextColor)),
                      focusColor: activeTextColor,
                      hintText: "Pasword",
                      hintStyle: inactiveTextStyle,
                      helperText: passwordHelper,
                      helperStyle: TextStyle(
                          color: helperColor(passwordError),
                          fontSize: helperSize),
                      icon: Icon(
                        Icons.vpn_key,
                        color: activeTextColor,
                      )),
                ),
                // Sign In Button
                roundedSquareButton(onSignInPressHandler, "Sign In"),
                // Sign Up Text
                Center(
                  child: RichText(
                    text: TextSpan(
                        text: r"Don't Have An Account? ",
                        style: TextStyle(
                            color: activeTextColor, fontSize: helperSize),
                        children: <TextSpan>[
                          TextSpan(
                              text: 'Sign Up',
                              style: TextStyle(
                                  color: activeButtonColor,
                                  fontSize: helperSize),
                              recognizer: TapGestureRecognizer()
                                ..onTap = () => onSignUpPressHandler())
                        ]),
                  ),
                ),
                // Placeholder
                Flexible(
                  child: Container(),
                  flex: 6,
                )
              ],
            )));
  }
}
