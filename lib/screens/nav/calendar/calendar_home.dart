import 'package:android_daily/models/schedule_data_source.dart';
import 'package:android_daily/screens/nav/calendar/calendar_change.dart';
import 'package:android_daily/style.dart';
import 'package:android_daily/models/schedule_item.dart';
import 'package:provider/provider.dart';

import 'package:syncfusion_flutter_calendar/calendar.dart';

import 'package:flutter/material.dart';

class CalendarHome extends StatefulWidget {
  const CalendarHome({Key? key}) : super(key: key);

  @override
  _CalendarHomeState createState() => _CalendarHomeState();
}

class _CalendarHomeState extends State<CalendarHome> {
  CalendarController calendarController = CalendarController();
  CalendarView mode = CalendarView.schedule;

  int getDefaultId(List<ScheduleItem>? alarmList) {
    List<ScheduleItem>? tmp = alarmList;
    if (tmp != null && tmp.isNotEmpty) {
      tmp.sort((a, b) => a.id.compareTo(b.id));
      return tmp.last.id + 1;
    } else {
      return 0;
    }
  }

  IconData calendarIcon(CalendarView mode) {
    switch (mode) {
      case CalendarView.schedule:
        return Icons.calendar_today;
      default:
        return Icons.calendar_view_day;
    }
  }

  void modeHandler() {
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

  void addHandler(int id) {
    Navigator.push(
        // Navigate To AlarmChange Page
        context,
        MaterialPageRoute(
          builder: (context) => CalendarChange(
            passedSchedule: ScheduleItem.fromMap({'id': id}),
          ),
        ));
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<List<ScheduleItem>?>(
      builder: (context, List<ScheduleItem>? scheduleList, child) {
        if (scheduleList == null) {
          return Scaffold(
            backgroundColor: backgroundColor,
            body: CircularProgressIndicator(color: activeButtonColor),
          );
        } else {
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
                      onPressed: modeHandler,
                    ),
                  ),
                ),
                Flexible(
                  flex: 12,
                  child: SfCalendar(
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
                  ),
                ),
              ],
            ),
            // Add Button
            floatingActionButton: FloatingActionButton(
              onPressed: () => addHandler(getDefaultId(scheduleList)),
              child: Icon(Icons.add),
              backgroundColor: activeButtonColor,
            ),
          );
        }
      },
    );
  }
}
