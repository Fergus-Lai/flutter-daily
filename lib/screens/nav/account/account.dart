import 'package:penguin/services/authenticaction_service.dart';
import 'package:penguin/style.dart';

import 'package:provider/provider.dart';

import 'package:flutter/material.dart';

class Account extends StatefulWidget {
  const Account({Key? key}) : super(key: key);

  @override
  _AccountState createState() => _AccountState();
}

class _AccountState extends State<Account> {
  Future<void> onSignOutPressedHandler() async {
    await context.read<AuthenticationService>().signOut();
  }

  // Build
  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
