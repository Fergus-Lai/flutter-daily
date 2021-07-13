import 'dart:math';

import 'package:android_daily/style.dart';
import 'package:intl/intl.dart';

import 'package:flutter/material.dart';

final Random random = new Random();

// Declaring DateFormatter and Time Foramtter With intl for date and time formatting
final DateFormat dateFormatter = DateFormat('yyyy-MM-dd');
final DateFormat timeFormatter = DateFormat('HH:mm');

class ScheduleItem {
  int id;
  DateTime startTime;
  DateTime endTime;
  String title;
  bool allDay;
  Color background;
  String recurrenceRule;
  ScheduleItem(
      {required this.id,
      required this.startTime,
      required this.endTime,
      required this.title,
      this.allDay = false,
      required this.background,
      this.recurrenceRule = ""});

  factory ScheduleItem.fromMap(Map<String, dynamic> data) {
    return ScheduleItem(
        id: data['id'],
        startTime: data['startTime'] == null
            ? DateTime.now().add(Duration(days: 1))
            : data['startTime'].toDate(),
        endTime: data['endTime'] == null
            ? data['startTime'] == null
                ? DateTime.now().add(Duration(days: 1, hours: 1))
                : data['startTime'].toDate().add(Duration(hours: 1))
            : data['endTime'].toDate(),
        title: data['title'] ?? '',
        allDay: data['allDay'] ?? false,
        background: data['background'] == null
            ? scheduleColor[random.nextInt(scheduleColor.length)]
            : Color(data['background']));
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'startTime': startTime,
      'endTime': endTime,
      'title': title,
      'allDay': allDay,
      'background': background.value,
      'recurrenceRule': recurrenceRule,
    };
  }

  String recurrenceRuleToString() {
    switch (recurrenceRule) {
      case "FREQ=DAILY;INTERVAL=1":
        return "Every Day";
      case "FREQ=WEEKLY;INTERVAL=1":
        return "Every Week";
      case "FREQ=MONTHLY;INTERVAL=1":
        return "Every Month";
      case "FREQ=YEARLY;INTERVAL=1":
        return "Every Year";
      default:
        return "Does Not Repeat";
    }
  }

  void toRecurrencRule(String recurrence) {
    switch (recurrence) {
      case "Does Not Repeat":
        recurrenceRule = "";
        break;
      case "Every Day":
        recurrenceRule = "FREQ=DAILY;INTERVAL=1";
        break;
      case "Every Week":
        recurrenceRule = "FREQ=WEEKLY;INTERVAL=1";
        break;
      case "Every Month":
        recurrenceRule = "FREQ=MONTHLY;INTERVAL=1";
        break;
      case "Every Year":
        recurrenceRule = "FREQ=YEARLY;INTERVAL=1";
        break;
    }
  }
}
