import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'home.dart';
import 'alarm/alarm_home.dart';
import 'calendar.dart';

void main() {
  runApp(const MyApp());
}

// Main application Widget
class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Flutter Daily',
      home: Nav(),
    );
  }
}

/// Create Stateful Widget Nav For Bottom Navigation Bar
class Nav extends StatefulWidget {
  const Nav({Key? key}) : super(key: key);

  @override
  State<Nav> createState() => _NavState();
}

/// Private State Class For Stateful Widget Nav
class _NavState extends State<Nav> {
  int _selectedIndex = 1; // Set Initial Route to Home
  List<Widget> _widgetOptions = <Widget>[
    AlarmHome(),
    Home(),
    Calendar(),
  ]; // Create List Of Page

  /// Press Handler For Bottom Navigation Bar
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.alarm),
            label: 'Alarm',
          ), // Alarm Item For Bottom Navigation Bar
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ), // Home Item For Bottom Navigation Bar
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_today),
            label: 'Calendar',
          ),
        ], // Calendar Item For Bottom Navigation Bar

        /// Style The Bottom Navigation Bar
        backgroundColor: Colors.black,
        selectedItemColor: Colors.purple[400],
        unselectedItemColor: Colors.grey[400],

        /// Config The Bottom Navigation Bar
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
    );
  }
}
