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
  List<AlarmItem> alarmList = [
    AlarmItem(id: 1, name: "Item 1", activate: true),
    AlarmItem(id: 2, name: "Item 2", activate: false),
    AlarmItem(id: 3, name: "Item 3", activate: true),
  ]; // Create Temp Alarm List

  /// On Press Handler For Add Button
  void addHandler() {
    Navigator.push(
      // Navigate To AlarmChange Page
      context,
      MaterialPageRoute(builder: (context) => AlarmChange()),
    );
  }

  /// On Press Handler For Disable Button
  void changeStateHandler() {}

  /// On Press Handler For Edit Button
  void editHandler() {}

  /// On Press Handler For Delete Button
  void deleteHandler() {}

  @override
  Widget build(BuildContext context) {
    /// Declare Variables For List Style
    Color? textColor;
    Color? changeStateColor;
    String changeStateText;
    IconData changeStateIcon;

    return Scaffold(
      backgroundColor: Colors.black,
      body: ListView.builder(
          // Create ListView Of All The Item In Alarm List
          itemCount: alarmList.length,
          itemBuilder: (context, index) {
            /// Set Style Variables According To The State Of The Item
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

            return Column(
              children: [
                Slidable(
                  actionPane: SlidableDrawerActionPane(),
                  actionExtentRatio: 0.225,
                  child: Container(
                      alignment: Alignment.centerLeft,
                      height: 60,
                      child: Padding(
                          padding:
                              EdgeInsets.only(left: 15, top: 10, bottom: 10),
                          child: Text('${alarmList[index].name}',
                              style:
                                  TextStyle(color: textColor, fontSize: 30)))),
                  actions: <Widget>[
                    IconSlideAction(
                      caption: changeStateText,
                      color: changeStateColor,
                      icon: changeStateIcon,
                      onTap: () => changeStateHandler(),
                    ), // Change State Button In List Slide
                    IconSlideAction(
                      caption: 'Edit',
                      color: Colors.lightBlue[900],
                      icon: Icons.edit,
                      onTap: () => editHandler(),
                    ), // Edit Button In List Slide
                    IconSlideAction(
                      caption: 'Delete',
                      color: Colors.red[900],
                      icon: Icons.delete,
                      onTap: () => deleteHandler(),
                    ), // Delete Button In List Slide
                  ],
                ),
                Divider(
                  height: 5,
                  thickness: 2,
                  color: Colors.grey[100],
                ) // Divider Between Item
              ],
            );
          }),

      /// Add Button
      floatingActionButton: FloatingActionButton(
        onPressed: () => addHandler(),
        child: const Icon(Icons.add),
        backgroundColor: Colors.cyan,
      ),
    );
  }
}
