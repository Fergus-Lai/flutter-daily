import 'package:android_daily/auth/sign_up.dart';
import 'package:android_daily/nav.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';

class SignIn extends StatefulWidget {
  const SignIn({Key? key}) : super(key: key);

  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignIn> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  String emailHelper = '';
  bool emailError = false;

  String passwordHelper = '';
  bool passwordError = false;

  void onSignUpPressHandler() {
    Navigator.push(context, MaterialPageRoute(builder: (context) => SignUp()));
  }

  Future<void> onSignInPressHandler() async {
    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(
              email: emailController.text, password: passwordController.text);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        setState(() {
          emailHelper = 'User Not Found';
          emailError = true;
          passwordHelper = '';
          passwordError = false;
        });
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
        backgroundColor: Colors.black,
        body: Column(
          children: [
            // Place Holder
            Flexible(
              flex: 1,
              child: Container(),
            ),
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
                    hintStyle: TextStyle(color: Colors.grey[400], fontSize: 20),
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
                  hintStyle: TextStyle(color: Colors.grey[400], fontSize: 20),
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
            // Sign In Button
            SizedBox(
                width: 250,
                child: ElevatedButton(
                    onPressed: onSignInPressHandler,
                    style: ElevatedButton.styleFrom(
                      shape: new RoundedRectangleBorder(
                        borderRadius: new BorderRadius.circular(30.0),
                      ),
                    ),
                    child: Text(
                      "Sign In",
                      style: TextStyle(fontSize: 20, color: Colors.white),
                    ))),
            // Sign Up Text
            Center(
              child: RichText(
                text: TextSpan(
                    text: r"Don't Have An Account? ",
                    style: TextStyle(color: Colors.grey[200], fontSize: 15),
                    children: <TextSpan>[
                      TextSpan(
                          text: 'Sign Up',
                          style:
                              TextStyle(color: Colors.lightBlue, fontSize: 15),
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
        ));
  }
}
