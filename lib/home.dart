import 'dart:async';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  DateTime now = DateTime.now();

  void updateTime() {
    if (mounted) {
      setState(() {
        now = DateTime.now();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final DateFormat dateFormatter = DateFormat('E d MMM yy');
    final DateFormat hourFormatter = DateFormat('HH:mm');

    Timer.periodic(Duration(seconds: 1), (timer) {
      updateTime();
    });
    return SafeArea(
        top: true,
        child: Container(
          color: Colors.black,
          child: Column(children: <Widget>[
            Flexible(child: Container(), flex: 1),
            Flexible(
                flex: 1,
                child: Container(
                    color: Colors.black,
                    alignment: Alignment.center,
                    child: Text(dateFormatter.format(now),
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 30,
                        )))), // Date Container
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
                )), // Time Container
            Flexible(
                flex: 12,
                child: Container(
                  color: Colors.black,
                  alignment: Alignment.center,
                ))
          ]),
        ));
  }
}
