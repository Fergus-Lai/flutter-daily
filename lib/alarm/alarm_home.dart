import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

import 'package:android_daily/alarm/alarm_change.dart';
import 'package:android_daily/alarm/alarm_item.dart';

/// Create Stateful Widget For AlarmHome Page
class AlarmHome extends StatefulWidget {
  const AlarmHome({Key? key}) : super(key: key);

  @override
  _AlarmHomeState createState() => _AlarmHomeState();
}

/// Private State Class For Stateful Widget AlarmHome Page
class _AlarmHomeState extends State<AlarmHome> {
  // Create Alarm List
  List<AlarmItem> alarmList = [
    AlarmItem(
        id: 1,
        title: "Item 1",
        time: '08:30',
        dowState: [false, false, false, true, true],
        activate: true),
    AlarmItem(
        id: 2,
        title: "Item 2",
        time: '10:30',
        dowState: [false, false, true, true, true],
        activate: false),
    AlarmItem(
        id: 3,
        title: "Item 3",
        time: '12:30',
        dowState: [false, true, false, true, true],
        activate: true),
  ];

  // On Press Handler For Add Button
  void addHandler() {
    Navigator.push(
        // Navigate To AlarmChange Page
        context,
        MaterialPageRoute(
          builder: (context) => AlarmChange(
            passedAlarm: AlarmItem(id: 4),
          ),
        ));
  }

  // On Press Handler For Disable Button
  void changeStateHandler() {}

  // On Press Handler For Edit Button
  void editHandler() {}

  // On Press Handler For Delete Button
  void deleteHandler() {}

  @override
  Widget build(BuildContext context) {
    // Declare Variables For List Style
    Color? textColor;
    Color? changeStateColor;
    String changeStateText;
    IconData changeStateIcon;

    // Create The Page
    return Scaffold(
      backgroundColor: Colors.black,
      // Create ListView Of All The Item In Alarm List
      body: ListView.builder(
          itemCount: alarmList.length,
          itemBuilder: (context, index) {
            // Set Style Variables According To The State Of The Item
            if (alarmList[index].activate) {
              textColor = Colors.white;
              changeStateText = 'Disable';
              changeStateIcon = Icons.pause;
              changeStateColor = Colors.amber;
            } else {
              textColor = Colors.grey[600];
              changeStateText = 'Enable';
              changeStateIcon = Icons.play_arrow;
              changeStateColor = Colors.green[900];
            }

            // List Item
            return Column(
              children: [
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
                                style:
                                    TextStyle(color: textColor, fontSize: 30)),
                            subtitle: Text('${alarmList[index].time}',
                                style:
                                    TextStyle(color: textColor, fontSize: 15)),
                          ))),
                  // List Of Buttons In The Slider
                  actions: <Widget>[
                    // Enable/Disable Button
                    IconSlideAction(
                      caption: changeStateText,
                      color: changeStateColor,
                      icon: changeStateIcon,
                      onTap: () => changeStateHandler(),
                    ),
                    // Edit Button
                    IconSlideAction(
                      caption: 'Edit',
                      color: Colors.lightBlue[900],
                      icon: Icons.edit,
                      onTap: () => editHandler(),
                    ),
                    // Delete Button
                    IconSlideAction(
                      caption: 'Delete',
                      color: Colors.red[900],
                      icon: Icons.delete,
                      onTap: () => deleteHandler(),
                    ),
                  ],
                ),
                // Divider
                Divider(
                  height: 5,
                  thickness: 2,
                  color: Colors.grey[100],
                )
              ],
            );
          }),

      // Add Button
      floatingActionButton: FloatingActionButton(
        onPressed: () => addHandler(),
        child: const Icon(Icons.add),
        backgroundColor: Colors.cyan,
      ),
    );
  }
}
