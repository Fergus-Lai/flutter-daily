import 'package:android_daily/auth/sign_in.dart';
import 'package:android_daily/nav.dart';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

FirebaseAuth auth = FirebaseAuth.instance;

// Main application Widget
class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool logIn = auth.currentUser == null ? false : true;

  void logInCheck() {
    auth.authStateChanges().listen((User? user) {
      if (user == null) {
        setState(() {
          logIn = false;
        });
      } else {
        setState(() {
          logIn = true;
        });
      }
    });
  }

  Widget _home() {
    if (logIn) {
      return Nav();
    } else {
      return SignIn();
    }
  }

  @override
  Widget build(BuildContext context) {
    logInCheck();
    return MaterialApp(
      title: 'Flutter Daily',
      home: _home(),
    );
  }
}
