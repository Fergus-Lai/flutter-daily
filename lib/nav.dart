import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'account/account.dart';
import 'home/home.dart';
import 'alarm/alarm_home.dart';
import 'calendar/calendar.dart';
import 'todo/todo_home.dart';

// Create Stateful Widget Nav For Bottom Navigation Bar
class Nav extends StatefulWidget {
  const Nav({Key? key}) : super(key: key);

  @override
  State<Nav> createState() => _NavState();
}

// Private State Class For Stateful Widget Nav
class _NavState extends State<Nav> {
  FirebaseAuth auth = FirebaseAuth.instance;
  // Set Initial Route to Home
  int _selectedIndex = 1;

  // Create List Of Page
  List<Widget> _widgetOptions = <Widget>[
    ToDoHome(),
    AlarmHome(),
    Home(),
    Calendar(),
    Account(),
  ];

  // On Press Handler For Bottom Navigation Bar
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  // Building The Main App
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () async => false,
        child: Scaffold(
          // Displaying The Page Selected
          body: Center(
            child: _widgetOptions.elementAt(_selectedIndex),
          ),

          // Bottom Navigation Bar
          bottomNavigationBar: BottomNavigationBar(
            // Set The Type To Fix
            type: BottomNavigationBarType.fixed,

            // Style The Bottom Navigation Bar
            backgroundColor: Colors.black,
            selectedItemColor: Colors.purple[400],
            unselectedItemColor: Colors.grey[400],

            // Items Displayed In Bottom Navigation Bar
            items: <BottomNavigationBarItem>[
              // Todo Item
              BottomNavigationBarItem(icon: Icon(Icons.list), label: 'Todo'),
              // Alarm Item
              BottomNavigationBarItem(
                icon: Icon(Icons.alarm),
                label: 'Alarm',
              ),
              // Home Item
              BottomNavigationBarItem(
                icon: Icon(Icons.home),
                label: 'Home',
              ),
              // Calendar Item
              BottomNavigationBarItem(
                icon: Icon(Icons.calendar_today),
                label: 'Calendar',
              ),
              // Account Item
              BottomNavigationBarItem(
                icon: Icon(Icons.person),
                label: 'Account',
              ),
            ],

            // Config The Bottom Navigation Bar
            currentIndex: _selectedIndex,
            onTap: _onItemTapped,
          ),
        ));
  }
}
