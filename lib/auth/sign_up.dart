import 'package:android_daily/auth/sign_in.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';

import 'package:android_daily/style.dart';

class SignUp extends StatefulWidget {
  const SignUp({Key? key}) : super(key: key);

  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  // Instances For Firebase
  final FirebaseAuth auth = FirebaseAuth.instance;
  final FirebaseFirestore db = FirebaseFirestore.instance;

  // Textt Editing Controller For Text Field
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController validationController = TextEditingController();
  final TextEditingController userNameController = TextEditingController();

  // Variable To Show Error
  String userNameHelper = '';
  bool userNameError = false;

  String emailHelper = '';
  bool emailError = false;

  String passwordHelper = '';
  bool passwordError = false;

  String validationHelper = '';
  bool validationError = false;

  // On Press Handler For Sign In Clickable Text
  void onSignInPressHandler() {
    Navigator.push(context, MaterialPageRoute(builder: (context) => SignIn()));
  }

  // On Press Handler For Sign Up Button
  Future<void> onSignUpPressHandler() async {
    // Reseting All Error Variables
    setState(() {
      validationError = false;
      validationHelper = '';
      emailError = false;
      emailHelper = '';
      passwordError = false;
      passwordHelper = '';
      userNameError = false;
      userNameHelper = '';
    });
    // Password Entered At Password Field And Validation Field Is Not The Same
    if (validationController.text != passwordController.text) {
      setState(() {
        validationError = true;
        validationHelper = 'Password Entered Are Not The Same';
        passwordError = true;
      });
      // Username Too Long
    } else if (userNameController.text.length > 20) {
      setState(() {
        userNameError = true;
        userNameHelper = 'User Name Too Long';
      });
    } else {
      try {
        // Create Account With The Email And Password
        await auth.createUserWithEmailAndPassword(
            email: emailController.text, password: passwordController.text);
        // Create Document in users collection
        await db.collection('users').doc(auth.currentUser!.uid).set({
          'Email': emailController.text,
          'Name': userNameController.text,
        });
        Navigator.pop(context);
      } on FirebaseAuthException catch (e) {
        // If Password Is Weak
        if ((e.code == 'weak-password')) {
          setState(() {
            passwordError = true;
            passwordHelper = 'Password Too Weak';
          });
          // If Email Is Used
        } else if (e.code == 'email-already-in-use') {
          setState(() {
            emailHelper = 'Account Already Exists';
            emailError = true;
          });
        }
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
                Flexible(
                  flex: 1,
                  child: Container(),
                ),
                // User Name Field
                TextField(
                    controller: userNameController,
                    keyboardType: TextInputType.text,
                    style: activeTextStyle,
                    decoration: InputDecoration(
                        enabledBorder: UnderlineInputBorder(
                            borderSide:
                                BorderSide(color: helperColor(userNameError))),
                        focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: activeTextColor)),
                        focusColor: activeTextColor,
                        hintText: "User Name",
                        hintStyle: inactiveTextStyle,
                        helperText: userNameHelper,
                        helperStyle: TextStyle(
                            color: helperColor(userNameError),
                            fontSize: helperSize),
                        icon: Icon(
                          Icons.person,
                          color: activeTextColor,
                        ))),
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
                // Validate Password Text Field
                TextField(
                  controller: validationController,
                  obscureText: true,
                  keyboardType: TextInputType.visiblePassword,
                  style: activeTextStyle,
                  decoration: InputDecoration(
                      enabledBorder: UnderlineInputBorder(
                          borderSide:
                              BorderSide(color: helperColor(validationError))),
                      focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: activeTextColor)),
                      focusColor: activeTextColor,
                      hintText: "Re-enter Password",
                      hintStyle: inactiveTextStyle,
                      helperText: validationHelper,
                      helperStyle: TextStyle(
                          color: helperColor(validationError),
                          fontSize: helperSize),
                      icon: Icon(
                        Icons.vpn_key,
                        color: activeTextColor,
                      )),
                ),
                // Sign Up Button
                roundedSquareButton(onSignUpPressHandler, "Sign Up"),
                // Sign In Text
                Center(
                  child: RichText(
                    text: TextSpan(
                        text: 'Already Have An Account? ',
                        style: TextStyle(
                            color: activeTextColor, fontSize: helperSize),
                        children: <TextSpan>[
                          TextSpan(
                              text: 'Sign In',
                              style: TextStyle(
                                  color: activeButtonColor,
                                  fontSize: helperSize),
                              recognizer: TapGestureRecognizer()
                                ..onTap = () => onSignInPressHandler())
                        ]),
                  ),
                ),
                // Placeholder
                Flexible(
                  child: Container(),
                  flex: 5,
                )
              ],
            )));
  }
}
