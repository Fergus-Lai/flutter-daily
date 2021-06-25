import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
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

  // On Press Handler For Add Button
  void addHandler() {
    Navigator.push(
        // Navigate To AlarmChange Page
        context,
        MaterialPageRoute(
          builder: (context) => AlarmChange(
            passedAlarm: AlarmItem(),
          ),
        ));
  }

  // On Press Handler For Disable Button
  void changeStateHandler(String id, bool state) {
    FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection('alarm')
        .doc(id)
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
  void deleteHandler(String id) {
    FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection('alarm')
        .doc(id)
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
            print(alarmList.connectionState);
            return Scaffold(
              backgroundColor: Colors.black,
              body: Center(
                child: (Text(
                  "Loading",
                  style: TextStyle(color: Colors.white, fontSize: 30),
                )),
              ),
            );
          } else {
            return Scaffold(
              backgroundColor: Colors.black,
              // Create ListView Of All The Item In Alarm List
              body: ListView.builder(
                  itemCount: alarmList.data!.length,
                  itemBuilder: (context, index) {
                    // Set Style Variables According To The State Of The Item
                    if (alarmList.data![index].activate) {
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
                                    title: Text(
                                        '${alarmList.data![index].title}',
                                        style: TextStyle(
                                            color: textColor, fontSize: 30)),
                                    subtitle: Text(
                                        '${alarmList.data![index].time}',
                                        style: TextStyle(
                                            color: textColor, fontSize: 15)),
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
                              color: Colors.lightBlue[900],
                              icon: Icons.edit,
                              onTap: () => editHandler(alarmList.data![index]),
                            ),
                            // Delete Button
                            IconSlideAction(
                              caption: 'Delete',
                              color: Colors.red[900],
                              icon: Icons.delete,
                              onTap: () =>
                                  deleteHandler(alarmList.data![index].id),
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
        });
  }
}
