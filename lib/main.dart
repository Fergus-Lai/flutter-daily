import 'package:android_daily/auth/sign_in.dart';
import 'package:android_daily/nav.dart';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();
Future<void> main() async {
  Future onDidReceiveLocalNotification(
      int id, String? title, String? body, String? payload) async {}

  Future selectNotification(String? payload) async {}

  WidgetsFlutterBinding.ensureInitialized();
  // Initialize Firebase App
  await Firebase.initializeApp();
  // Initialize Flutter Local Notification
  const AndroidInitializationSettings initializationSettingsAndroid =
      AndroidInitializationSettings('app_icon');
  final IOSInitializationSettings initializationSettingsIOS =
      IOSInitializationSettings(
          requestAlertPermission: true,
          requestBadgePermission: true,
          requestSoundPermission: true,
          onDidReceiveLocalNotification: onDidReceiveLocalNotification);
  final MacOSInitializationSettings initializationSettingsMacOS =
      MacOSInitializationSettings();
  final InitializationSettings initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsIOS,
      macOS: initializationSettingsMacOS);
  await flutterLocalNotificationsPlugin.initialize(initializationSettings,
      onSelectNotification: selectNotification);
  runApp(MyApp());
}

// Firebase Auth Instance
FirebaseAuth auth = FirebaseAuth.instance;

// Main application Widget
class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  // Initialize Widget App Used For Home
  Widget app = auth.currentUser == null ? SignIn() : Nav();

  // Listen To Auth State Change And Change Page According To User Value
  void logInCheck() {
    auth.authStateChanges().listen((User? user) {
      if (user == null) {
        setState(() {
          app = SignIn();
        });
      } else {
        setState(() {
          app = Nav();
        });
      }
    });
  }

  // Building The App
  @override
  Widget build(BuildContext context) {
    logInCheck();
    return MaterialApp(
      title: 'Flutter Daily',
      home: app,
    );
  }
}
