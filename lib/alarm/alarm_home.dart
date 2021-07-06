import 'package:android_daily/style.dart';
import 'package:android_daily/alarm/alarm_change.dart';
import 'package:android_daily/alarm/alarm_item.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

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
  // Fetech Alarm List From Cloud Store
  Stream<List<AlarmItem>> getAlarmList() {
    Stream<QuerySnapshot> collection = FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection('alarm')
        .orderBy('activate', descending: true)
        .orderBy('time')
        .snapshots();
    Stream<List<AlarmItem>> alarmList = collection.map((qShot) => qShot.docs
        .map((doc) => AlarmItem(
            id: doc.get('id'),
            title: doc.get('title'),
            time: doc.get('time'),
            dowState: AlarmItem.getDowState(doc.get('dowState')),
            activate: (doc.get('activate') == '1') ? true : false))
        .toList());
    return alarmList;
  }

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
  void addHandler(int id) {
    Navigator.push(
        // Navigate To AlarmChange Page
        context,
        MaterialPageRoute(
          builder: (context) => AlarmChange(
            passedAlarm: AlarmItem(id: id),
          ),
        ));
  }

  // On Press Handler For Disable Button
  void changeStateHandler(int id, bool state) {
    FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection('alarm')
        .doc(id.toString())
        .update({"activate": state ? "0" : "1"});
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
  void deleteHandler(int id) {
    FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection('alarm')
        .doc(id.toString())
        .delete();
  }

  @override
  Widget build(BuildContext context) {
    // Declare Variables For List Style
    Color? textColor;
    Color? changeStateColor;
    String changeStateText;
    IconData changeStateIcon;
    // Create The Page
    return StreamBuilder(
        stream: getAlarmList(),
        builder: (context, AsyncSnapshot<List<AlarmItem>> alarmList) {
          if (alarmList.connectionState != ConnectionState.active) {
            return Scaffold(
              appBar: AppBar(
                backgroundColor: backgroundColor,
              ),
              backgroundColor: backgroundColor,
              body: Center(
                child: (Text(
                  "Loading",
                  style: titleTextStyle,
                )),
              ),
            );
          } else {
            return WillPopScope(
                onWillPop: () async => false,
                child: Scaffold(
                  backgroundColor: backgroundColor,
                  // Create ListView Of All The Item In Alarm List
                  body: ListView.builder(
                      itemCount: alarmList.data!.length,
                      itemBuilder: (context, index) {
                        // Set Style Variables According To The State Of The Item
                        if (alarmList.data![index].activate) {
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
                                        title: Text(
                                            '${alarmList.data![index].title}',
                                            style: TextStyle(
                                                color: textColor,
                                                fontSize: titleSize)),
                                        subtitle: Text(
                                            '${alarmList.data![index].time}',
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
                                  onTap: () => changeStateHandler(
                                      alarmList.data![index].id,
                                      alarmList.data![index].activate),
                                ),
                                // Edit Button
                                IconSlideAction(
                                  caption: 'Edit',
                                  color: editColor,
                                  icon: Icons.edit,
                                  onTap: () =>
                                      editHandler(alarmList.data![index]),
                                ),
                                // Delete Button
                                IconSlideAction(
                                  caption: 'Delete',
                                  color: warningColor,
                                  icon: Icons.delete,
                                  onTap: () =>
                                      deleteHandler(alarmList.data![index].id),
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
                    onPressed: () => addHandler(getDefaultId(alarmList.data)),
                    child: Icon(Icons.add),
                    backgroundColor: activeButtonColor,
                  ),
                ));
          }
        });
  }
}
