import 'package:android_daily/models/schedule_item.dart';

import 'package:syncfusion_flutter_calendar/calendar.dart';

import 'package:flutter/material.dart';

class ScheduleDataSource extends CalendarDataSource {
  ScheduleDataSource(List<ScheduleItem> source) {
    appointments = source;
  }

  @override
  DateTime getStartTime(int index) {
    return appointments![index].startTime;
  }

  @override
  DateTime getEndTime(int index) {
    return appointments![index].endTime;
  }

  @override
  Color getColor(int index) {
    return appointments![index].background;
  }

  @override
  String getEndTimeZone(int index) {
    return "";
  }

  @override
  List<DateTime> getRecurrenceExceptionDates(int index) {
    return [];
  }

  @override
  String getRecurrenceRule(int index) {
    return appointments![index].recurrenceRule;
  }

  @override
  String getStartTimeZone(int index) {
    return "";
  }

  @override
  String getSubject(int index) {
    return appointments![index].title;
  }

  @override
  bool isAllDay(int index) {
    return appointments![index].allDay;
  }
}
