import 'package:android_daily/auth/sign_in.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';

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
        backgroundColor: Colors.black,
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
                    style: TextStyle(color: Colors.white, fontSize: 20),
                    decoration: InputDecoration(
                        enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(
                                color: userNameError
                                    ? Colors.red.shade900
                                    : Colors.grey.shade600)),
                        focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.white)),
                        focusColor: Colors.white,
                        hintText: "User Name",
                        hintStyle:
                            TextStyle(color: Colors.grey[400], fontSize: 20),
                        helperText: userNameHelper,
                        helperStyle: TextStyle(
                            color: userNameError
                                ? Colors.red.shade900
                                : Colors.grey.shade600,
                            fontSize: 15),
                        icon: Icon(
                          Icons.person,
                          color: Colors.white,
                        ))),
                // Email Text Field
                TextField(
                    controller: emailController,
                    keyboardType: TextInputType.emailAddress,
                    style: TextStyle(color: Colors.white, fontSize: 20),
                    decoration: InputDecoration(
                        enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(
                                color: emailError
                                    ? Colors.red.shade900
                                    : Colors.grey.shade600)),
                        focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.white)),
                        focusColor: Colors.white,
                        hintText: "Email",
                        hintStyle:
                            TextStyle(color: Colors.grey[400], fontSize: 20),
                        helperText: emailHelper,
                        helperStyle: TextStyle(
                            color: emailError
                                ? Colors.red.shade900
                                : Colors.grey.shade600,
                            fontSize: 15),
                        icon: Icon(
                          Icons.mail,
                          color: Colors.white,
                        ))),
                // Password Text Field
                TextField(
                  controller: passwordController,
                  obscureText: true,
                  keyboardType: TextInputType.visiblePassword,
                  style: TextStyle(color: Colors.white, fontSize: 20),
                  decoration: InputDecoration(
                      enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                              color: passwordError
                                  ? Colors.red.shade900
                                  : Colors.grey.shade600)),
                      focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.white)),
                      focusColor: Colors.white,
                      hintText: "Pasword",
                      hintStyle:
                          TextStyle(color: Colors.grey[400], fontSize: 20),
                      helperText: passwordHelper,
                      helperStyle: TextStyle(
                          color: passwordError
                              ? Colors.red.shade900
                              : Colors.grey.shade600,
                          fontSize: 15),
                      icon: Icon(
                        Icons.vpn_key,
                        color: Colors.white,
                      )),
                ),
                // Validate Password Text Field
                TextField(
                  controller: validationController,
                  obscureText: true,
                  keyboardType: TextInputType.visiblePassword,
                  style: TextStyle(color: Colors.white, fontSize: 20),
                  decoration: InputDecoration(
                      enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                              color: validationError
                                  ? Colors.red.shade900
                                  : Colors.grey.shade600)),
                      focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.white)),
                      focusColor: Colors.white,
                      hintText: "Re-enter Password",
                      hintStyle:
                          TextStyle(color: Colors.grey[400], fontSize: 20),
                      helperText: validationHelper,
                      helperStyle: TextStyle(
                          color: validationError
                              ? Colors.red.shade900
                              : Colors.grey.shade600,
                          fontSize: 15),
                      icon: Icon(
                        Icons.vpn_key,
                        color: Colors.white,
                      )),
                ),
                // Sign Up Button
                SizedBox(
                    width: 250,
                    child: ElevatedButton(
                        onPressed: onSignUpPressHandler,
                        style: ElevatedButton.styleFrom(
                          shape: new RoundedRectangleBorder(
                            borderRadius: new BorderRadius.circular(30.0),
                          ),
                        ),
                        child: Text(
                          "Sign Up",
                          style: TextStyle(fontSize: 20, color: Colors.white),
                        ))),
                // Sign In Text
                Center(
                  child: RichText(
                    text: TextSpan(
                        text: 'Already Have An Account? ',
                        style: TextStyle(color: Colors.grey[200], fontSize: 15),
                        children: <TextSpan>[
                          TextSpan(
                              text: 'Sign In',
                              style: TextStyle(
                                  color: Colors.lightBlue, fontSize: 15),
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
