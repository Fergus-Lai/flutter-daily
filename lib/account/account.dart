import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/material.dart';

import 'package:android_daily/style.dart';

class Account extends StatelessWidget {
  // Firebase Auth Instance
  final FirebaseAuth auth = FirebaseAuth.instance;

  // Sign Out Press Handler
  Future<void> onSignOutPressedHandler() async {
    await auth.signOut();
  }

  // Build
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: backgroundColor,
      ),
      backgroundColor: backgroundColor,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          // Place Holder
          Flexible(
            flex: 1,
            child: Container(),
          ),
          // Sign Out Button
          SizedBox(
              width: 200,
              child: ElevatedButton(
                  onPressed: onSignOutPressedHandler,
                  style: ElevatedButton.styleFrom(
                    primary: activeButtonColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30.0),
                    ),
                  ),
                  child: Text(
                    'Sign Out',
                    style: TextStyle(color: activeTextColor, fontSize: 20),
                  ))),
          // Place Holder
          Flexible(
            flex: 1,
            child: Container(),
          ),
        ],
      ),
    );
  }
}
