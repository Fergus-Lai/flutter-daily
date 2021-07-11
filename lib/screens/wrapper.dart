import 'package:android_daily/screens/authenticate/sign_in.dart';
import 'package:android_daily/screens/nav/nav.dart';

import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/material.dart';

class Wrapper extends StatelessWidget {
  const Wrapper({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    User? firebaseUser = context.watch<User?>();
    return firebaseUser != null ? Nav() : SignIn();
  }
}
