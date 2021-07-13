import 'package:android_daily/services/database_service.dart';
import 'package:android_daily/services/notification_service.dart';
import 'package:android_daily/style.dart';
import 'package:android_daily/screens/nav/alarm/alarm_change.dart';
import 'package:android_daily/models/alarm_item.dart';

import 'package:provider/provider.dart';

import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

/// Create Stateful Widget For AlarmHome Page
class AlarmHome extends StatefulWidget {
  const AlarmHome({Key? key}) : super(key: key);

  @override
  _AlarmHomeState createState() => _AlarmHomeState();
}

/// Private State Class For Stateful Widget AlarmHome Page
class _AlarmHomeState extends State<AlarmHome> {
  // Get Default ID From Alarm List
  int getDefaultId(List<AlarmItem>? alarmList) {
    List<AlarmItem>? tmp = alarmList;
    if (tmp != null && tmp.isNotEmpty) {
      tmp.sort((a, b) => a.id.compareTo(b.id));
      return tmp.last.id + 1;
    } else {
      return 0;
    }
  }

  // On Press Handler For Add Button
  void onAddPressHandler(int id) {
    Navigator.push(
        // Navigate To AlarmChange Page
        context,
        MaterialPageRoute(
          builder: (context) => AlarmChange(
            passedAlarm: AlarmItem.fromMap({'id': id}),
          ),
        ));
  }

  // On Press Handler For Disable Button
  void changeStateHandler(AlarmItem alarm) {
    context.read<DatabaseService>().changeAlarmState(alarm);
  }

  // On Press Handler For Edit Button
  void editHandler(AlarmItem alarm) {
    Navigator.push(
        // Navigate To AlarmChange Page
        context,
        MaterialPageRoute(
          builder: (context) => AlarmChange(
            passedAlarm: alarm,
          ),
        ));
  }

  // On Press Handler For Delete Button
  void deleteHandler(AlarmItem alarm) {
    context.read<DatabaseService>().deleteAlarm(alarm);
    context.read<NotificationService>().cancelAlarm(alarm.id);
  }

  @override
  Widget build(BuildContext context) {
    // Declare Variables For List Style
    Color? textColor;
    Color? changeStateColor;
    String changeStateText;
    IconData changeStateIcon;
    // Create The Page
    return WillPopScope(
      onWillPop: () async => false,
      child: Consumer<List<AlarmItem>?>(
        builder: (context, List<AlarmItem>? alarmList, child) {
          if (alarmList == null) {
            return CircularProgressIndicator(color: activeButtonColor);
          } else {
            return Scaffold(
              backgroundColor: backgroundColor,
              // Create ListView Of All The Item In Alarm List
              body: ListView.builder(
                  itemCount: alarmList.length,
                  itemBuilder: (context, index) {
                    // Set Style Variables According To The State Of The Item
                    if (alarmList[index].activate) {
                      textColor = activeTextColor;
                      changeStateText = 'Disable';
                      changeStateIcon = Icons.pause;
                      changeStateColor = Colors.amber;
                    } else {
                      textColor = inactiveColor;
                      changeStateText = 'Enable';
                      changeStateIcon = Icons.play_arrow;
                      changeStateColor = safeColor;
                    }

                    // List Item
                    return Column(
                      children: <Widget>[
                        // Creating Slider
                        Slidable(
                          actionPane: SlidableDrawerActionPane(),
                          actionExtentRatio: 0.225,
                          // Display Item Name
                          child: Container(
                              alignment: Alignment.centerLeft,
                              height: 60,
                              child: Padding(
                                  padding: EdgeInsets.only(left: 10),
                                  child: ListTile(
                                    title: Text('${alarmList[index].title}',
                                        style: TextStyle(
                                            color: textColor,
                                            fontSize: titleSize)),
                                    subtitle: Text('${alarmList[index].time}',
                                        style: TextStyle(
                                            color: textColor,
                                            fontSize: helperSize)),
                                  ))),
                          // List Of Buttons In The Slider
                          actions: <Widget>[
                            // Enable/Disable Button
                            IconSlideAction(
                              caption: changeStateText,
                              color: changeStateColor,
                              icon: changeStateIcon,
                              onTap: () => changeStateHandler(alarmList[index]),
                            ),
                            // Edit Button
                            IconSlideAction(
                              caption: 'Edit',
                              color: editColor,
                              icon: Icons.edit,
                              onTap: () => editHandler(alarmList[index]),
                            ),
                            // Delete Button
                            IconSlideAction(
                              caption: 'Delete',
                              color: warningColor,
                              icon: Icons.delete,
                              onTap: () => deleteHandler(alarmList[index]),
                            ),
                          ],
                        ),
                        // Divider
                        divider(),
                      ],
                    );
                  }),

              // Add Button
              floatingActionButton: FloatingActionButton(
                onPressed: () => onAddPressHandler(getDefaultId(alarmList)),
                child: Icon(Icons.add),
                backgroundColor: activeButtonColor,
              ),
            );
          }
        },
      ),
    );
  }
}
