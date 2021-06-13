import 'dart:async';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

// Create Formatter For Date And Hour To String
final DateFormat dateFormatter = DateFormat('E d MMM yy');
final DateFormat hourFormatter = DateFormat('HH:mm');

// Create Stateful Widget Home For Home Page
class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

// Private State Class For Stateful Widget Nav
class _HomeState extends State<Home> {
  // Initialize Variable now With The Current Time
  DateTime now = DateTime.now();

  // Function For Updating The Variable now When The Page Is Loaded
  void updateTime() {
    if (mounted) {
      setState(() {
        now = DateTime.now();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // Calls The updateTime Function Every Seconds To Update Variable now
    Timer.periodic(Duration(seconds: 1), (timer) {
      updateTime();
    });
    return Container(
      color: Colors.black,
      child: Column(children: <Widget>[
        // Place Holder
        Flexible(child: Container(), flex: 2),
        // Digital Clock Date
        Flexible(
            flex: 1,
            child: Container(
                color: Colors.black,
                alignment: Alignment.center,
                child: Text(dateFormatter.format(now),
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 30,
                    )))),
        // Digital Clock Time
        Flexible(
            flex: 1,
            child: Container(
              color: Colors.black,
              alignment: Alignment.center,
              child: Text(hourFormatter.format(now),
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 30,
                  )),
            )),
        // Schedule List
        Flexible(
            flex: 12,
            child: Container(
              color: Colors.black,
              alignment: Alignment.center,
            ))
      ]),
    );
  }
}
