import 'package:intl/intl.dart';

// Declaring DateFormatter With intl for dateformatting
final DateFormat dateFormatter = DateFormat('HH:mm');

// Class For Storing Each Alarm
class AlarmItem {
  int id;
  String title;
  String time;
  List<dynamic> dowState;
  bool activate;
  AlarmItem(
      {required this.id,
      required this.title,
      required this.time,
      required this.dowState,
      required this.activate});

  factory AlarmItem.fromMap(Map<String, dynamic> data) {
    return AlarmItem(
      id: data['id'],
      title: data['title'] ?? 'Alarm',
      time: data['time'] ?? dateFormatter.format(DateTime.now()),
      dowState:
          data['dowState'] ?? [false, true, true, true, true, true, false],
      activate: data['activate'] ?? true,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'time': time,
      'dowState': dowState,
      'activate': activate,
    };
  }

  // Convert String time to DateTime With Today Date
  DateTime timeToDateTime() {
    DateTime now = DateTime.now();
    return DateTime(now.year, now.month, now.day,
        int.parse(this.time.split(":")[0]), int.parse(this.time.split(":")[1]));
  }

  // Function For Getting The Duration Between The Next Alarm And Now
  int nextAlarmIn() {
    DateTime now = DateTime.now();
    DateTime tmp = timeToDateTime();
    int i = now.weekday;
    // Do While Loop For Checking The Closest Weekday Which The dowState Is True
    do {
      if (dowState[i % 7]) {
        tmp = tmp.add(Duration(days: (i - now.weekday)));
        return tmp.difference(now).inMinutes;
      }
      i++;
    } while (i % 7 != now.weekday % 7);
    // The Time of tmp Is Faster Than now
    if ((tmp.hour >= now.hour) && (tmp.minute >= now.minute)) {
      return tmp.difference(now).inMinutes;
    } // The Time of tmp Is Slower Than Now
    else {
      tmp = tmp.add(Duration(days: 1));
      return tmp.difference(now).inMinutes;
    }
  }
}
