import 'package:android_daily/models/alarm_item.dart';
import 'package:android_daily/screens/nav/alarm/alarm_home.dart';
import 'package:android_daily/screens/nav/calendar/calendar_home.dart';
import 'package:android_daily/screens/wrapper.dart';
import 'package:android_daily/services/authenticaction_service.dart';
import 'package:android_daily/services/database_service.dart';
import 'package:android_daily/services/notification_init.dart';
import 'package:android_daily/services/notification_service.dart';
import 'package:android_daily/style.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import 'package:provider/provider.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Initialize Firebase App
  await Firebase.initializeApp();
  // Initialize Flutter Local Notification
  await NotificationInit().init();
  // Initialize Timezone for Notification
  tz.initializeTimeZones();
  runApp(MyApp());
}

// Main application Widget
class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  // Building The App
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<AuthenticationService>(
          create: (_) => AuthenticationService(FirebaseAuth.instance),
        ),
        Provider<DatabaseService>(
          create: (_) => DatabaseService(
              FirebaseAuth.instance, FirebaseFirestore.instance),
        ),
        Provider<NotificationService>(
          create: (_) => NotificationService(FlutterLocalNotificationsPlugin()),
        ),
        StreamProvider<User?>(
            create: (context) =>
                context.read<AuthenticationService>().authStateChanges,
            initialData: null),
        StreamProvider<List<AlarmItem>?>(
          create: (context) => context.read<DatabaseService>().streamAlarm(),
          initialData: null,
          child: AlarmHome(),
        ),
        StreamProvider(
          create: (context) => context.read<DatabaseService>().streamSchedule(),
          initialData: null,
          child: CalendarHome(),
        )
      ],
      child: MaterialApp(
        theme: ThemeData(
            dialogBackgroundColor: dialogColor,
            unselectedWidgetColor: inactiveColor),
        title: 'Flutter Daily',
        home: Wrapper(),
      ),
    );
  }
}
