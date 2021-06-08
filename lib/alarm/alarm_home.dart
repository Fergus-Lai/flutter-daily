import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:android_daily/alarm/alarm_change.dart';

class AlarmItem {
  final int id;
  final String name;
  final bool activate;

  AlarmItem({required this.id, required this.name, required this.activate});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'activate': activate,
    };

    @override
    String toString() {
      return 'AlarmItem(id: $id, name: $name, age: $activate)';
    }
  }
}

class AlarmHome extends StatefulWidget {
  const AlarmHome({Key? key}) : super(key: key);

  @override
  _AlarmHomeState createState() => _AlarmHomeState();
}

class _AlarmHomeState extends State<AlarmHome> {
  List<AlarmItem> alarmList = [
    AlarmItem(id: 1, name: "Item 1", activate: true),
    AlarmItem(id: 2, name: "Item 2", activate: false),
    AlarmItem(id: 3, name: "Item 3", activate: true),
  ];

  void addHandler() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => AlarmChange()),
    );
  }

  void disableHandler() {}

  void editHandler() {}

  void deleteHandler() {}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: ListView.builder(
          itemCount: alarmList.length,
          itemBuilder: (context, index) {
            if (alarmList[index].activate) {
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
                                style: TextStyle(
                                    color: Colors.white, fontSize: 30)))),
                    actions: <Widget>[
                      IconSlideAction(
                        caption: 'Disable',
                        color: Colors.amber,
                        icon: Icons.pause,
                        onTap: () => disableHandler(),
                      ),
                      IconSlideAction(
                        caption: 'Edit',
                        color: Colors.lightBlue[900],
                        icon: Icons.edit,
                        onTap: () => editHandler(),
                      ),
                      IconSlideAction(
                        caption: 'Delete',
                        color: Colors.red[900],
                        icon: Icons.delete,
                        onTap: () => deleteHandler(),
                      ),
                    ],
                  ),
                  Divider(
                    height: 5,
                    thickness: 2,
                    color: Colors.grey[100],
                  )
                ],
              );
            } else {
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
                                style: TextStyle(
                                    color: Colors.grey[600], fontSize: 30)))),
                    actions: <Widget>[
                      IconSlideAction(
                        caption: 'Disable',
                        color: Colors.amber,
                        icon: Icons.pause,
                        onTap: () => disableHandler(),
                      ),
                      IconSlideAction(
                        caption: 'Edit',
                        color: Colors.lightBlue[900],
                        icon: Icons.edit,
                        onTap: () => editHandler(),
                      ),
                      IconSlideAction(
                        caption: 'Delete',
                        color: Colors.red[900],
                        icon: Icons.delete,
                        onTap: () => deleteHandler(),
                      ),
                    ],
                  ),
                  Divider(
                    height: 5,
                    thickness: 2,
                    color: Colors.grey[100],
                  )
                ],
              );
            }
          }),
      floatingActionButton: FloatingActionButton(
        onPressed: () => addHandler(),
        child: const Icon(Icons.add),
        backgroundColor: Colors.cyan,
      ),
    );
  }
}
