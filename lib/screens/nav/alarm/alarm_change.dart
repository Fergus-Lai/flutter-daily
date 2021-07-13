import 'package:penguin/services/database_service.dart';
import 'package:penguin/services/notification_service.dart';
import 'package:penguin/style.dart';
import 'package:penguin/models/alarm_item.dart';

import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

// Create Time Formatter
final timeForamtter = DateFormat("HH:mm");

// Create Stateful Widget For AlarmChange Page
class AlarmChange extends StatefulWidget {
  final AlarmItem passedAlarm;
  AlarmChange({Key? key, required this.passedAlarm}) : super(key: key);

  @override
  _AlarmChangeState createState() => new _AlarmChangeState(passedAlarm);
}

// Private State Class For Stateful Widget AlarmChange Page
class _AlarmChangeState extends State<AlarmChange> {
  // Declare Variable For AlarmItem
  AlarmItem alarm;
  _AlarmChangeState(this.alarm);

  // Text Editing Controller For Title Text Field
  late TextEditingController titleController;

  @override
  void initState() {
    titleController = TextEditingController(text: alarm.title);
    super.initState();
  }

  // Function For Displaying Duration Between Next Alarm And Now
  String nextAlarmDisplay(int gap) {
    // Getting Days, Hours And Mins With The Gap Value
    int days = gap ~/ 1440;
    int hours = (gap % 1440) ~/ 60;
    int mins = (gap % 1440) % 60;

    // Returning The Displayed Message
    if (days == 0) {
      if (hours == 0) {
        if (mins == 0) {
          return "Ring in Less Than 1 Minute";
        } else if (mins == 1) {
          return "Ring in 1 Minute";
        } else {
          return "Ring in $mins Minutes";
        }
      } else if (hours == 1) {
        if (mins == 0) {
          return "Ring in 1 Hour";
        } else if (mins == 1) {
          return "Ring in 1 Hour and 1 Minute";
        } else {
          return "Ring in 1 Hour and $mins Minutes";
        }
      } else {
        if (mins == 0) {
          return "Ring in $hours Hours";
        } else if (mins == 1) {
          return "Ring in $hours Hours and 1 Minute";
        } else {
          return "Ring in $hours Hour and $mins Minutes";
        }
      }
    } else if (days == 1) {
      if (hours == 0) {
        if (mins == 0) {
          return "Ring in 1 Day";
        } else if (mins == 1) {
          return "Ring in 1 Day and 1 Minute";
        } else {
          return "Ring in 1 Day and $mins Minutes";
        }
      } else if (hours == 1) {
        if (mins == 0) {
          return "Ring in 1 Day and 1 Hour";
        } else if (mins == 1) {
          return "Ring in 1 Day and 1 Hour and 1 Minute";
        } else {
          return "Ring in 1 Day and 1 Hour and $mins Minutes";
        }
      } else {
        if (mins == 0) {
          return "Ring in 1 Day and $hours Hours";
        } else if (mins == 1) {
          return "Ring in 1 Day and $hours Hours and 1 Minute";
        } else {
          return "Ring in 1 Day and $hours Hour and $mins Minutes";
        }
      }
    } else {
      if (hours == 0) {
        if (mins == 0) {
          return "Ring in $days Day";
        } else if (mins == 1) {
          return "Ring in $days Days and 1 Minute";
        } else {
          return "Ring in $days Days and $mins Minutes";
        }
      } else if (hours == 1) {
        if (mins == 0) {
          return "Ring in $days Days and 1 Hour";
        } else if (mins == 1) {
          return "Ring in $days Days and 1 Hour and 1 Minute";
        } else {
          return "Ring in $days Days and 1 Hour and $mins Minutes";
        }
      } else {
        if (mins == 0) {
          return "Ring in $days Days and $hours Hours";
        } else if (mins == 1) {
          return "Ring in $days Days and $hours Hours and 1 Minute";
        } else {
          return "Ring in $days Days and $hours Hour and $mins Minutes";
        }
      }
    }
  }

  // Handle Press On The Day Of Week Button
  void dayOfWeekOnPressHandler(int dow) {
    setState(() {
      alarm.dowState[dow] = !alarm.dowState[dow];
    });
  }

// Function For Generating Each Day Of Week Button
  Widget dayOfWeekButtonGenerator(int dow, List<dynamic> dowState) {
    String? text;
    switch (dow) {
      // Switch For Setting Display Word Of Day Of Week
      case 0:
        {
          text = 'S';
        }
        break;
      case 1:
        {
          text = 'M';
        }
        break;
      case 2:
        {
          text = 'T';
        }
        break;
      case 3:
        {
          text = 'W';
        }
        break;
      case 4:
        {
          text = 'T';
        }
        break;
      case 5:
        {
          text = 'F';
        }
        break;
      case 6:
        {
          text = 'S';
        }
        break;
    }
    // Setting The Color Of The Button According To True or False In the dowState[dow]
    Color color = dowState[dow] ? activeButtonColor : inactiveColor;
    // Returning The Button
    return SizedBox(
        height: MediaQuery.of(context).size.width / 8,
        width: MediaQuery.of(context).size.width / 8,
        child: ElevatedButton(
            onPressed: () => dayOfWeekOnPressHandler(dow),
            child: Container(child: Text('$text')),
            style: ElevatedButton.styleFrom(
                primary: color,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0)))));
  }

  // Handle Scrolling Action For Time Picking
  void onTimeChangeHandler(DateTime time, timeFormatter) {
    setState(() {
      alarm.time = timeFormatter.format(time);
    });
  }

  // Handle Delete Button Press
  void onCancelPressHandler() {
    Navigator.pop(context);
  }

  // Handle Confirm Button Press
  void onConfirmPressHandler() async {
    alarm.title = titleController.text;
    // Store To Firestore
    context.read<DatabaseService>().updateAlarm(alarm);
    // Setting Notification
    context.read<NotificationService>().setAlarmNotification(alarm);
    // Go Back To Alarm Home
    Navigator.pop(context);
  }

  @override
  // Build The Page
  Widget build(BuildContext context) {
    return Scaffold(
        // Avoid Resize The Screen With Keyboard
        resizeToAvoidBottomInset: false,
        backgroundColor: backgroundColor,
        body: Column(
          children: [
            // Place Holder
            Flexible(
              flex: 1,
              child: Container(),
            ),
            // Time Picker
            Flexible(
                flex: 4,
                child: CupertinoTheme(
                  data: CupertinoThemeData(
                    textTheme: CupertinoTextThemeData(
                      dateTimePickerTextStyle: activeTextStyle,
                    ),
                  ),
                  child: CupertinoDatePicker(
                    mode: CupertinoDatePickerMode.time,
                    initialDateTime: alarm.timeToDateTime(),
                    use24hFormat: true,
                    minuteInterval: 1,
                    onDateTimeChanged: (time) =>
                        {onTimeChangeHandler(time, timeForamtter)},
                  ),
                )),
            // Place Holder
            Flexible(
              flex: 1,
              child: Container(),
            ),
            // Day Of Week Button Row
            Flexible(
              flex: 2,
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: List<Widget>.generate(
                      7,
                      (index) =>
                          dayOfWeekButtonGenerator(index, alarm.dowState))),
            ),
            // Display The Time Between Next Alarm and Now
            Flexible(
              flex: 1,
              child: Center(
                  child: Text(nextAlarmDisplay(alarm.nextAlarmIn()),
                      style: TextStyle(fontSize: 18, color: activeTextColor))),
            ),
            // Divider
            divider(),
            // Text Input For Title
            Flexible(
              flex: 2,
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 5, horizontal: 20),
                child: TextField(
                  controller: titleController,
                  keyboardType: TextInputType.text,
                  style: activeTextStyle,
                  decoration: InputDecoration(
                      enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: inactiveColor)),
                      focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: activeTextColor)),
                      focusColor: activeTextColor,
                      hintText: "Title",
                      hintStyle: inactiveTextStyle,
                      icon: Icon(
                        Icons.title,
                        color: activeTextColor,
                      )),
                ),
              ),
            ),
            // Row Of Delete And Confirm Button
            Flexible(
                flex: 2,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    // Delete Button
                    ElevatedButton(
                        onPressed: onCancelPressHandler,
                        style: ButtonStyle(
                            backgroundColor:
                                MaterialStateProperty.all(warningColor)),
                        child: Row(
                          children: [
                            Icon(Icons.close, color: activeTextColor),
                            Text(
                              "Cancel",
                              style: activeTextStyle,
                            ),
                          ],
                        )),
                    // Confirm Button
                    ElevatedButton(
                        onPressed: onConfirmPressHandler,
                        style: ElevatedButton.styleFrom(primary: safeColor),
                        child: Row(
                          children: [
                            Icon(Icons.done, color: activeTextColor),
                            Text(
                              "Confirm",
                              style: activeTextStyle,
                            ),
                          ],
                        )),
                  ],
                )),
            // Place Holder
            Flexible(flex: 10, child: Container())
          ],
        ));
  }
}
