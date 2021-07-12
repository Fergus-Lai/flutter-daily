import 'dart:math';

import 'package:android_daily/style.dart';
import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

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
            : DateTime.fromMillisecondsSinceEpoch(data['startTime'] * 1000),
        endTime: data['endTime'] == null
            ? data['startTime'] == null
                ? DateTime.now().add(Duration(days: 1, hours: 1))
                : DateTime.fromMillisecondsSinceEpoch(data['startTime'] * 1000)
                    .add(Duration(hours: 1))
            : DateTime.fromMillisecondsSinceEpoch(data['endTime'] * 1000),
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
}
