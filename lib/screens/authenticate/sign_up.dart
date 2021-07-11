import 'package:android_daily/screens/authenticate/sign_in.dart';
import 'package:android_daily/services/authenticaction_service.dart';
import 'package:android_daily/services/database_service.dart';
import 'package:android_daily/style.dart';

import 'package:provider/provider.dart';

import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';

class SignUp extends StatefulWidget {
  const SignUp({Key? key}) : super(key: key);

  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  // Textt Editing Controller For Text Field
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController validationController = TextEditingController();
  final TextEditingController userNameController = TextEditingController();

  // Variable To Show Error
  String userNameHelper = '';

  String emailHelper = '';

  String passwordHelper = '';

  String validationHelper = '';

  // On Press Handler For Sign In Clickable Text
  void onSignInPressHandler() {
    Navigator.push(context, MaterialPageRoute(builder: (context) => SignIn()));
  }

  // On Press Handler For Sign Up Button
  Future<void> onSignUpPressHandler() async {
    // Reseting All Error Variables
    setState(() {
      validationHelper = '';
      emailHelper = '';
      passwordHelper = '';
      userNameHelper = '';
    });
    // Password Entered At Password Field And Validation Field Is Not The Same
    if (validationController.text != passwordController.text) {
      setState(() {
        validationHelper = 'Password Entered Are Not The Same';
      });
      // Username Too Long
    } else if (userNameController.text.length > 20) {
      setState(() {
        userNameHelper = 'User Name Too Long';
      });
    } else {
      String code = await context.read<AuthenticationService>().signUp(
          email: emailController.text, password: passwordController.text);
      // If Password Is Weak
      if ((code == 'weak-password')) {
        setState(() {
          passwordHelper = 'Password Too Weak';
        });
        // If Email Is Used
      } else if (code == 'email-already-in-use') {
        setState(() {
          emailHelper = 'Account Already Exists';
        });
      } else if (code == 'Signed Up') {
        await context
            .read<DatabaseService>()
            .register(emailController.text, userNameController.text);
        Navigator.pop(context);
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
                            borderSide: BorderSide(
                                color: helperColor(userNameHelper.isNotEmpty))),
                        focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: activeTextColor)),
                        focusColor: activeTextColor,
                        hintText: "User Name",
                        hintStyle: inactiveTextStyle,
                        helperText: userNameHelper,
                        helperStyle: TextStyle(
                            color: helperColor(userNameHelper.isNotEmpty),
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
                            borderSide: BorderSide(
                                color: helperColor(emailHelper.isNotEmpty))),
                        focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: activeTextColor)),
                        focusColor: activeTextColor,
                        hintText: "Email",
                        hintStyle: inactiveTextStyle,
                        helperText: emailHelper,
                        helperStyle: TextStyle(
                            color: helperColor(emailHelper.isNotEmpty),
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
                          borderSide: BorderSide(
                              color: helperColor(passwordHelper.isNotEmpty))),
                      focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: activeTextColor)),
                      focusColor: activeTextColor,
                      hintText: "Pasword",
                      hintStyle: inactiveTextStyle,
                      helperText: passwordHelper,
                      helperStyle: TextStyle(
                          color: helperColor(passwordHelper.isNotEmpty),
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
                          borderSide: BorderSide(
                              color: helperColor(validationHelper.isNotEmpty))),
                      focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: activeTextColor)),
                      focusColor: activeTextColor,
                      hintText: "Re-enter Password",
                      hintStyle: inactiveTextStyle,
                      helperText: validationHelper,
                      helperStyle: TextStyle(
                          color: helperColor(validationHelper.isNotEmpty),
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
