import 'package:penguin/models/schedule_item.dart';
import 'package:penguin/services/database_service.dart';
import 'package:penguin/style.dart';

import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

final DateFormat dateFormatter = DateFormat("E d MMM yyyy");
final DateFormat timeFormatter = DateFormat("HH:mm");

class CalendarChange extends StatefulWidget {
  final ScheduleItem passedSchedule;
  const CalendarChange({Key? key, required this.passedSchedule})
      : super(key: key);

  @override
  _CalendarChangeState createState() =>
      new _CalendarChangeState(passedSchedule);
}

class _CalendarChangeState extends State<CalendarChange> {
  ScheduleItem scheduleItem;
  _CalendarChangeState(this.scheduleItem);

  late TextEditingController titleController;

  @override
  void initState() {
    titleController = TextEditingController(text: scheduleItem.title);
    super.initState();
  }

  // Handle All Day Switch
  void onAllDaySwitchHandler(bool value) {
    setState(() {
      scheduleItem.allDay = value;
      scheduleItem.startTime = DateTime(scheduleItem.startTime.year,
          scheduleItem.startTime.month, scheduleItem.startTime.day, 0, 0);
      scheduleItem.endTime = DateTime(scheduleItem.endTime.year,
          scheduleItem.endTime.month, scheduleItem.endTime.day, 0, 0);
    });
  }

  // Handle Time Text Press
  Future<void> onTimePressHandler(String mode) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: mode == "Start"
          ? TimeOfDay.fromDateTime(scheduleItem.startTime)
          : TimeOfDay.fromDateTime(scheduleItem.endTime),
    );
    if (picked != null) {
      setState(() {
        mode == "Start"
            ? scheduleItem.startTime = DateTime(
                scheduleItem.startTime.year,
                scheduleItem.startTime.month,
                scheduleItem.startTime.day,
                picked.hour,
                picked.minute)
            : scheduleItem.endTime = DateTime(
                scheduleItem.endTime.year,
                scheduleItem.endTime.month,
                scheduleItem.endTime.day,
                picked.hour,
                picked.minute);
      });
    }
  }

  // Handle Date Text Press
  Future<void> onDatePressHandler(String mode) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate:
            mode == "Start" ? scheduleItem.startTime : scheduleItem.endTime,
        firstDate: DateTime.now(),
        lastDate: DateTime(2101));
    if (picked != null) {
      setState(() {
        mode == "Start"
            ? scheduleItem.startTime = DateTime(picked.year, picked.month,
                picked.day, picked.hour, picked.minute)
            : scheduleItem.endTime = DateTime(
                picked.year,
                picked.month,
                picked.day,
                scheduleItem.endTime.hour,
                scheduleItem.endTime.minute);
      });
    }
  }

  // Handle Repeat Row Press
  void onRepeatPressHandler() {
    showDialog(
      context: context,
      builder: (context) {
        final selected = scheduleItem.recurrenceRuleToString();
        const option = [
          "Does Not Repeat",
          "Every Day",
          "Every Week",
          "Every Month",
          "Every Year",
        ];
        return AlertDialog(
          content: Container(
            child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: option
                    .map(
                      (e) => RadioListTile(
                        contentPadding: EdgeInsets.symmetric(horizontal: 5),
                        activeColor: activeButtonColor,
                        title: Text(
                          e,
                          style:
                              TextStyle(color: activeTextColor, fontSize: 20),
                        ),
                        value: e,
                        groupValue: selected,
                        onChanged: (String? value) {
                          setState(() {
                            scheduleItem.toRecurrencRule(value!);
                          });
                          Navigator.pop(context);
                        },
                      ),
                    )
                    .toList()),
          ),
        );
      },
    );
  }

  // Handle Color Row Press
  void onColorPressHandler() {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            content: GridView.count(
              crossAxisCount: 3,
              children: List.generate(
                scheduleColor.length,
                (index) {
                  return Center(
                    child: TextButton(
                      onPressed: () {
                        setState(() {
                          scheduleItem.background = scheduleColor[index];
                        });
                        Navigator.pop(context);
                      },
                      child: Container(
                        height: 50,
                        width: 50,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: scheduleColor[index],
                        ),
                        child: scheduleItem.background == scheduleColor[index]
                            ? Icon(
                                Icons.check,
                                color: backgroundColor,
                              )
                            : null,
                      ),
                    ),
                  );
                },
              ),
            ),
          );
        });
  }

  // Handle Cancel Button Press
  void onCancelPressHandler() {
    Navigator.pop(context);
  }

  // Handle Confirm Button Press
  void onConfirmPressHandler() {
    // Setting Title To Title Controller Text
    scheduleItem.title = titleController.text;
    // Storing To Firebase
    context.read<DatabaseService>().updateSchedule(scheduleItem);
    // Pop Back To Calendar Home
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: backgroundColor,
      body: Column(
        children: [
          // Placeholder
          Flexible(
            flex: 2,
            child: Container(),
          ),
          // Title Text Field
          Flexible(
            flex: 2,
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
              child: TextField(
                controller: titleController,
                keyboardType: TextInputType.text,
                style: activeTextStyle,
                decoration: InputDecoration(
                  focusColor: activeTextColor,
                  hintText: "Title",
                  hintStyle: inactiveTextStyle,
                  icon: Icon(
                    Icons.title,
                    color: activeTextColor,
                  ),
                ),
              ),
            ),
          ),
          divider(),
          // All Day Row
          Expanded(
            flex: 2,
            child: Padding(
              padding: EdgeInsets.only(left: 10, right: 10, top: 5),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  RichText(
                    text: TextSpan(
                      // All Day Text And Icon
                      children: [
                        // Icon
                        WidgetSpan(
                          child: Icon(
                            Icons.schedule,
                            color: activeTextColor,
                          ),
                        ),
                        // Text
                        WidgetSpan(
                          child: Padding(
                            padding: EdgeInsets.only(left: 16),
                            child: Text(
                              "All Day",
                              style: activeTextStyle,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  // All Day Switch
                  Padding(
                    padding: EdgeInsets.only(right: 25),
                    child: Transform.scale(
                      scale: 0.85,
                      child: CupertinoSwitch(
                        value: scheduleItem.allDay,
                        onChanged: onAllDaySwitchHandler,
                        activeColor: activeButtonColor,
                        trackColor: inactiveColor,
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
          // Start Time Row
          Expanded(
            flex: 2,
            child: Padding(
              padding: EdgeInsets.only(left: scheduleItem.allDay ? 41.5 : 10),
              child: Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: scheduleItem.allDay
                    ? MainAxisAlignment.start
                    : MainAxisAlignment.spaceAround,
                children: [
                  TextButton(
                    style: TextButton.styleFrom(textStyle: activeTextStyle),
                    onPressed: () => onDatePressHandler("Start"),
                    child: Text(
                      dateFormatter.format(scheduleItem.startTime),
                      style: activeTextStyle,
                    ),
                  ),
                  if (!scheduleItem.allDay)
                    TextButton(
                      style: TextButton.styleFrom(textStyle: activeTextStyle),
                      onPressed: () => onTimePressHandler("Start"),
                      child: Text(
                        timeFormatter.format(scheduleItem.startTime),
                        textAlign: TextAlign.end,
                        style: activeTextStyle,
                      ),
                    ),
                ],
              ),
            ),
          ),
          // End Time Row
          Expanded(
            flex: 2,
            child: Padding(
              padding: EdgeInsets.only(left: scheduleItem.allDay ? 41.5 : 10),
              child: Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: scheduleItem.allDay
                    ? MainAxisAlignment.start
                    : MainAxisAlignment.spaceAround,
                children: [
                  TextButton(
                    style: TextButton.styleFrom(textStyle: activeTextStyle),
                    onPressed: () => onDatePressHandler("End"),
                    child: Text(
                      dateFormatter.format(scheduleItem.endTime),
                      style: activeTextStyle,
                    ),
                  ),
                  if (!scheduleItem.allDay)
                    TextButton(
                      style: TextButton.styleFrom(textStyle: activeTextStyle),
                      onPressed: () => onTimePressHandler("End"),
                      child: Text(
                        timeFormatter.format(scheduleItem.endTime),
                        textAlign: TextAlign.end,
                        style: activeTextStyle,
                      ),
                    ),
                ],
              ),
            ),
          ),
          // Recurrence Rule Row
          Expanded(
            flex: 2,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Icon(
                    Icons.autorenew,
                    color: activeTextColor,
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 8),
                    child: TextButton(
                      style: TextButton.styleFrom(textStyle: activeTextStyle),
                      onPressed: onRepeatPressHandler,
                      child: (Text(
                        scheduleItem.recurrenceRuleToString(),
                        style: activeTextStyle,
                      )),
                    ),
                  ),
                ],
              ),
            ),
          ),
          divider(),
          // Color Row
          Expanded(
            flex: 2,
            child: InkWell(
              onTap: onColorPressHandler,
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 12),
                child: Row(
                  children: [
                    SizedBox(
                      width: 20,
                      height: 20,
                      child: DecoratedBox(
                        decoration: BoxDecoration(
                            color: scheduleItem.background,
                            shape: BoxShape.circle),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 18),
                      child: Text(
                        "Color",
                        style: activeTextStyle,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          divider(),
          // Delete And Confirm Button Row
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
          Flexible(
            flex: 10,
            child: Container(),
          ),
        ],
      ),
    );
  }
}
