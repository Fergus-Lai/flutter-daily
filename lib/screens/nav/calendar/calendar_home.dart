import 'package:penguin/models/schedule_data_source.dart';
import 'package:penguin/screens/nav/calendar/calendar_change.dart';
import 'package:penguin/services/database_service.dart';
import 'package:penguin/style.dart';
import 'package:penguin/models/schedule_item.dart';
import 'package:provider/provider.dart';

import 'package:syncfusion_flutter_calendar/calendar.dart';

import 'package:flutter/material.dart';

class CalendarHome extends StatefulWidget {
  const CalendarHome({Key? key}) : super(key: key);

  @override
  _CalendarHomeState createState() => _CalendarHomeState();
}

class _CalendarHomeState extends State<CalendarHome> {
  // Creating Calendar Controller
  CalendarController calendarController = CalendarController();
  // Default View Value
  CalendarView mode = CalendarView.schedule;

  // Getting Default ID
  int getDefaultId(List<ScheduleItem>? alarmList) {
    List<ScheduleItem>? tmp = alarmList;
    if (tmp != null && tmp.isNotEmpty) {
      tmp.sort((a, b) => a.id.compareTo(b.id));
      return tmp.last.id + 1;
    } else {
      return 0;
    }
  }

  // Setting Calendar View Mode Icon
  IconData calendarIcon(CalendarView mode) {
    switch (mode) {
      case CalendarView.schedule:
        return Icons.calendar_today;
      default:
        return Icons.calendar_view_day;
    }
  }

  // Handle Change Mode Button Press
  void onModePressHandler() {
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

  // Handle Add Button Press
  void onAddPressHandler(int id) {
    Navigator.push(
        // Navigate To AlarmChange Page
        context,
        MaterialPageRoute(
          builder: (context) => CalendarChange(
            passedSchedule: ScheduleItem.fromMap({'id': id}),
          ),
        ));
  }

  // Handle Calendar Press
  void onCalendarPressHandler(CalendarTapDetails calendarTapDetails) {
    if (calendarTapDetails.appointments!.length == 1) {
      Navigator.push(
        // Navigate To AlarmChange Page
        context,
        MaterialPageRoute(
          builder: (context) => CalendarChange(
            passedSchedule: calendarTapDetails.appointments![0],
          ),
        ),
      );
    }
  }

  // Handle Calendar Long Press
  void onCalendarLongPressHandler(CalendarLongPressDetails calendarTapDetails) {
    if (calendarTapDetails.appointments!.length == 1) {
      showDialog(
          context: context,
          builder: (context) {
            // Show Alert Dialog To Confirm Delete
            return AlertDialog(
              content: Text(
                "Delete Appointment?",
                style: activeTextStyle,
              ),
              actions: [
                TextButton(
                  child: Text(
                    "Cancel",
                    style: activeTextStyle,
                  ),
                  onPressed: () => {Navigator.pop(context)},
                ),
                TextButton(
                  child: Text(
                    "Confirm",
                    style: activeTextStyle,
                  ),
                  onPressed: () {
                    context
                        .read<DatabaseService>()
                        .deleteSchedule(calendarTapDetails.appointments![0]);
                    Navigator.pop(context);
                  },
                )
              ],
            );
          });
    }
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
                // Place Holder
                Flexible(
                  flex: 1,
                  child: Container(),
                ),
                // Mode Change Button
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
                      onPressed: onModePressHandler,
                    ),
                  ),
                ),
                // Calendar
                Flexible(
                  flex: 12,
                  child: SfCalendar(
                    onTap: onCalendarPressHandler,
                    onLongPress: onCalendarLongPressHandler,
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
                        appointmentItemHeight: 70,
                        appointmentTextStyle: activeTextStyle,
                        dayHeaderSettings: DayHeaderSettings(
                            dayTextStyle: TextStyle(
                                color: activeTextColor, fontSize: helperSize),
                            dateTextStyle: activeTextStyle)),
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
              onPressed: () => onAddPressHandler(getDefaultId(scheduleList)),
              child: Icon(Icons.add),
              backgroundColor: activeButtonColor,
            ),
          );
        }
      },
    );
  }
}
