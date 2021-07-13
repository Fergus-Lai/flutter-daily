import 'dart:typed_data';

import 'package:penguin/models/alarm_item.dart';

import 'package:uuid/uuid.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationService {
  final Uuid uuid = Uuid();
  final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin;

  NotificationService(this._flutterLocalNotificationsPlugin);

  Future<void> setAlarmNotification(AlarmItem alarm) async {
    // Cancelling Alarm With The Same ID
    _flutterLocalNotificationsPlugin.cancel(alarm.id);
    // Creating Alarm
    const int insistentFlag = 4; // Flag For Repeat Until Clicked
    // Android Notification Setting
    final AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
      uuid.v1(), // Channel ID
      'alarm', // Channel Name
      'alarm channel', // Channel Description
      importance: Importance.max,
      priority: Priority.max,
      showWhen: false,
      sound: RawResourceAndroidNotificationSound('alarm'),
      additionalFlags: Int32List.fromList(<int>[insistentFlag]),
    );
    // IOS Notification Detail (Todo)
    final IOSNotificationDetails iosNotificationDetails =
        IOSNotificationDetails(presentAlert: true, presentSound: true);
    final NotificationDetails platformChannelSpecifics = NotificationDetails(
        android: androidPlatformChannelSpecifics, iOS: iosNotificationDetails);
    // Setting Alarm
    if (alarm.dowState.contains(true)) {
      DateTime now = DateTime.now();
      DateTime tmp = alarm.timeToDateTime();
      int i = now.weekday;
      do {
        i++;
        if (alarm.dowState[i % 7]) {
          await _flutterLocalNotificationsPlugin.zonedSchedule(
              alarm.id,
              alarm.title,
              "Tap To Dismiss",
              tz.TZDateTime.from(
                  tmp.add(Duration(days: i - now.weekday)), tz.local),
              platformChannelSpecifics,
              uiLocalNotificationDateInterpretation:
                  UILocalNotificationDateInterpretation.absoluteTime,
              androidAllowWhileIdle: true,
              matchDateTimeComponents: DateTimeComponents
                  .dayOfWeekAndTime //Repeat At The Day Of Week And Time
              );
        }
      } while (i % 7 != now.weekday % 7);
    } else {
      await _flutterLocalNotificationsPlugin.zonedSchedule(
          alarm.id,
          alarm.title,
          "Tap To Dismiss",
          tz.TZDateTime.now(tz.local)
              .add(Duration(seconds: (alarm.nextAlarmIn() * 60) + 1)),
          platformChannelSpecifics,
          uiLocalNotificationDateInterpretation:
              UILocalNotificationDateInterpretation.absoluteTime,
          androidAllowWhileIdle: true,
          payload: alarm.id.toString());
    }
  }

  Future<void> cancelAlarm(int id) async {
    await _flutterLocalNotificationsPlugin.cancel(id);
  }
}
