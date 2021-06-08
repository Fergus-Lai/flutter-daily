import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

final hourStyle = TextStyle(color: Colors.white, fontSize: 20);

class AlarmChange extends StatefulWidget {
  const AlarmChange({Key? key}) : super(key: key);

  @override
  _AlarmChangeState createState() => _AlarmChangeState();
}

class _AlarmChangeState extends State<AlarmChange> {
  DateTime dateTime = DateTime.now();
  DateTime selectedTime = DateTime.now();
  List<bool> dayOfWeekState =
      List.from([false, true, true, true, true, true, false], growable: false);

  void dayOfWeekOnPressHandler(int dow) {
    setState(() {
      dayOfWeekState[dow] = !dayOfWeekState[dow];
    });
  }

  Widget dayOfWeekButtonGenerator(int dow) {
    String? text;
    switch (dow) {
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
    Color? color = dayOfWeekState[dow] ? Colors.cyan : Colors.grey[600];
    return Flexible(
        child: ConstrainedBox(
            constraints: BoxConstraints.tightFor(width: 30, height: 30),
            child: ElevatedButton(
                onPressed: () => dayOfWeekOnPressHandler(dow),
                child: Text('$text'),
                style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(color),
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5),
                    ))))));
  }

  void onTimeChangeManager(DateTime time) {
    setState(() {
      selectedTime = time;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
            color: Colors.black,
            child: Column(
              children: [
                Flexible(
                    flex: 1,
                    child: Container(
                      color: Colors.black,
                    )),
                Flexible(
                    flex: 2,
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
                Flexible(
                  flex: 1,
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List<Widget>.generate(
                          7, (index) => dayOfWeekButtonGenerator(index))),
                ),
                Flexible(
                  flex: 1,
                  child: Container(
                    color: Colors.black,
                    child: Text('$selectedTime', style: hourStyle),
                  ),
                ),
                Divider(
                  color: Colors.white,
                  height: 5,
                  thickness: 2,
                ),
                Flexible(
                    flex: 8,
                    child: Container(
                      color: Colors.black,
                    ))
              ],
            )));
  }
}
