import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';
import 'package:android_daily/alarm/alarm_item.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

// Create Style Variable
final hourStyle = TextStyle(color: Colors.white, fontSize: 20);

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
  Widget dayOfWeekButtonGenerator(int dow, List<bool> dowState) {
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
    Color? color = dowState[dow] ? Colors.cyan : Colors.grey[600];
    // Returning The Button
    return Flexible(
        flex: 1,
        child: AspectRatio(
            aspectRatio: 1,
            child: ElevatedButton(
                onPressed: () => dayOfWeekOnPressHandler(dow),
                child: Container(child: Text('$text')),
                style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(color)))));
  }

  // Handle Scrolling Action For Time Picking
  void onTimeChangeManager(DateTime time, timeFormatter) {
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
    await FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection('alarm')
        .doc(alarm.id)
        .set({
      'id': alarm.id,
      'title': titleController.text,
      'time': alarm.time,
      'dowState': alarm.dowStateToString(),
      'activate': alarm.activate ? '1' : '0',
    });
    Navigator.pop(context);
  }

  @override
  // Build The Page
  Widget build(BuildContext context) {
    return Scaffold(
        // Avoid Resize The Screen With Keyboard
        resizeToAvoidBottomInset: false,
        body: Container(
            color: Colors.black,
            child: Column(
              children: [
                // Place Holder
                Flexible(
                    flex: 2,
                    child: Container(
                      color: Colors.black,
                    )),
                // Time Picker
                Flexible(
                    flex: 4,
                    child: CupertinoTheme(
                      data: CupertinoThemeData(
                        textTheme: CupertinoTextThemeData(
                          dateTimePickerTextStyle: hourStyle,
                        ),
                      ),
                      child: CupertinoDatePicker(
                        mode: CupertinoDatePickerMode.time,
                        initialDateTime: alarm.timeToDateTime(),
                        use24hFormat: true,
                        minuteInterval: 1,
                        onDateTimeChanged: (time) =>
                            {onTimeChangeManager(time, timeForamtter)},
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
                      mainAxisAlignment: MainAxisAlignment.center,
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
                          style: TextStyle(fontSize: 18, color: Colors.white))),
                ),
                // Divider
                Divider(
                  color: Colors.white,
                  height: 5,
                  thickness: 2,
                ),
                // Text Input For Title
                Flexible(
                  flex: 2,
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: 5, horizontal: 20),
                    child: Container(
                      child: TextField(
                        controller: titleController,
                        keyboardType: TextInputType.text,
                        style: TextStyle(color: Colors.white, fontSize: 20),
                        decoration: InputDecoration(
                            enabledBorder: UnderlineInputBorder(
                                borderSide:
                                    BorderSide(color: Colors.grey.shade600)),
                            focusedBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.white)),
                            focusColor: Colors.white,
                            hintText: "Title",
                            hintStyle: TextStyle(
                                color: Colors.grey[400], fontSize: 20),
                            icon: Icon(
                              Icons.title,
                              color: Colors.white,
                            )),
                      ),
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
                                backgroundColor: MaterialStateProperty.all(
                                    Colors.red.shade800)),
                            child: Row(
                              children: [
                                Icon(Icons.close, color: Colors.white),
                                Text(
                                  "Cancel",
                                  style: TextStyle(
                                      fontSize: 20, color: Colors.white),
                                ),
                              ],
                            )),
                        // Confirm Button
                        ElevatedButton(
                            onPressed: onConfirmPressHandler,
                            style: ButtonStyle(
                                backgroundColor: MaterialStateProperty.all(
                                    Colors.green.shade800)),
                            child: Row(
                              children: [
                                Icon(Icons.done, color: Colors.white),
                                Text(
                                  "Confirm",
                                  style: TextStyle(
                                      fontSize: 20, color: Colors.white),
                                ),
                              ],
                            )),
                      ],
                    )),
                // Place Holder
                Flexible(
                    flex: 10,
                    child: Container(
                      color: Colors.black,
                    ))
              ],
            )));
  }
}
