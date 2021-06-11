import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

/// Create Style Variable
final hourStyle = TextStyle(color: Colors.white, fontSize: 20);

/// Create Stateful Widget For AlarmChange Page
class AlarmChange extends StatefulWidget {
  const AlarmChange({Key? key}) : super(key: key);

  @override
  _AlarmChangeState createState() => _AlarmChangeState();
}

/// Private State Class For Stateful Widget AlarmChange Page
class _AlarmChangeState extends State<AlarmChange> {
  // Function For Getting The Duration Between The Next Alarm And Now
  int nextAlarmIn(List<bool> dowState, DateTime time, DateTime now) {
    DateTime tmp = time;
    if ((tmp.weekday == now.weekday) &&
        (tmp.hour >= now.hour) &&
        (tmp.minute >= now.minute)) {
      return tmp.difference(now).inMinutes;
    } else if (!(dowState.contains(true))) {
      if ((tmp.weekday == now.weekday) &&
          (tmp.hour >= now.hour) &&
          (tmp.minute >= now.minute)) {
        return tmp.difference(now).inMinutes;
      } else {
        tmp = tmp.add(Duration(days: 1));
        return tmp.difference(now).inMinutes;
      }
    } else {
      int i = now.weekday;
      do {
        i++;
        if (dowState[i % 7]) {
          tmp = tmp.add(Duration(days: i - now.weekday));
          return tmp.difference(now).inMinutes;
        }
      } while (i != now.weekday);
      return 0;
    }
  }

// Function For Displaying Duration Between Next Alarm And Now
  String nextAlarmDisplay(int gap) {
    int days = gap ~/ 1440;
    int hours = (gap % 1440) ~/ 60;
    int mins = (gap % 1440) % 60;
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

// List Of Week Storing Which Day Of The Week The Alarm Is Active
  List<bool> dayOfWeekState =
      List.from([false, true, true, true, true, true, false], growable: false);

// Declare Variable For Date
  DateTime selectedTime = DateTime.now();
  int gap = 0;

// Handle Press On The Day Of Week Button
  void dayOfWeekOnPressHandler(int dow, DateTime time) {
    setState(() {
      dayOfWeekState[dow] = !dayOfWeekState[dow];
      gap = nextAlarmIn(dayOfWeekState, time, DateTime.now());
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
                onPressed: () => dayOfWeekOnPressHandler(dow, selectedTime),
                child: Container(child: Text('$text')),
                style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(color)))));
  }

  // Handle Scrolling Action For Time Picking
  void onTimeChangeManager(DateTime time) {
    setState(() {
      selectedTime = time;
      gap = nextAlarmIn(dayOfWeekState, time, DateTime.now());
    });
  }

  // Handle Delete Button Press
  void onDeletePressHandler() {}

  // Handle Confirm Button Press
  void onConfirmPressHandler() {}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset:
            false, // Avoid Resize The Screen With Keyboard
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
                        initialDateTime: DateTime.now(),
                        use24hFormat: true,
                        minuteInterval: 1,
                        onDateTimeChanged: (time) =>
                            {onTimeChangeManager(time)},
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
                              dayOfWeekButtonGenerator(index, dayOfWeekState))),
                ),
                // Display The Time Between Next Alarm and Now
                Flexible(
                  flex: 1,
                  child: Center(
                      child: Text(nextAlarmDisplay(gap),
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
                            onPressed: onDeletePressHandler,
                            style: ButtonStyle(
                                backgroundColor: MaterialStateProperty.all(
                                    Colors.red.shade800)),
                            child: Row(
                              children: [
                                Icon(Icons.delete, color: Colors.white),
                                Text(
                                  "Delete",
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
                                Icon(Icons.check, color: Colors.white),
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
