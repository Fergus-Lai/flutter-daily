import 'package:android_daily/models/schedule_data_source.dart';
import 'package:android_daily/style.dart';
import 'package:android_daily/models/schedule_item.dart';
import 'package:provider/provider.dart';

import 'package:syncfusion_flutter_calendar/calendar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:flutter/material.dart';

class CalendarHome extends StatefulWidget {
  const CalendarHome({Key? key}) : super(key: key);

  @override
  _CalendarHomeState createState() => _CalendarHomeState();
}

class _CalendarHomeState extends State<CalendarHome> {
  CalendarController calendarController = CalendarController();
  CalendarView mode = CalendarView.schedule;
  IconData calendarIcon(CalendarView mode) {
    switch (mode) {
      case CalendarView.schedule:
        return Icons.calendar_today;
      default:
        return Icons.calendar_view_day;
    }
  }

  void onPressed() {
    setState(() {
      switch (mode) {
        case CalendarView.schedule:
          mode = CalendarView.month;
          break;
        default:
          mode = CalendarView.schedule;
      }
    });

    calendarController.view = mode;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      body: Column(
        children: [
          Flexible(
            flex: 1,
            child: Container(),
          ),
          Flexible(
            flex: 1,
            child: Container(
              alignment: Alignment.centerRight,
              child: IconButton(
                splashRadius: 20,
                icon: Icon(
                  calendarIcon(mode),
                  color: activeButtonColor,
                ),
                onPressed: onPressed,
              ),
            ),
          ),
          Flexible(
            flex: 12,
            child: Consumer<List<ScheduleItem>?>(
                builder: (context, List<ScheduleItem>? scheduleList, child) {
              if (scheduleList == null) {
                return CircularProgressIndicator(color: activeButtonColor);
              } else {
                return SfCalendar(
                  dataSource: ScheduleDataSource(scheduleList),
                  cellBorderColor: inactiveColor,
                  controller: calendarController,
                  view: CalendarView.schedule,
                  allowedViews: [],
                  viewHeaderStyle:
                      ViewHeaderStyle(dayTextStyle: inactiveTextStyle),
                  todayTextStyle: activeTextStyle,
                  todayHighlightColor: activeButtonColor,
                  backgroundColor: backgroundColor,
                  headerStyle: CalendarHeaderStyle(textStyle: titleTextStyle),
                  scheduleViewSettings: ScheduleViewSettings(
                    hideEmptyScheduleWeek: true,
                  ),
                  monthViewSettings: MonthViewSettings(
                    appointmentDisplayCount: 2,
                    appointmentDisplayMode:
                        MonthAppointmentDisplayMode.indicator,
                    showTrailingAndLeadingDates: true,
                    showAgenda: true,
                    agendaStyle: AgendaStyle(
                        appointmentTextStyle: activeTextStyle,
                        dayTextStyle: activeTextStyle,
                        dateTextStyle: activeTextStyle),
                    monthCellStyle: MonthCellStyle(
                      textStyle: activeTextStyle,
                      trailingDatesTextStyle: inactiveTextStyle,
                      leadingDatesTextStyle: inactiveTextStyle,
                    ),
                  ),
                );
              }
            }),
          ),
        ],
      ),
    );
  }
}
