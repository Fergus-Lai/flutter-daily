import 'package:intl/intl.dart';

// Declaring DateFormatter With intl for dateformatting
final DateFormat dateFormatter = DateFormat('HH:mm');

// Class For Storing Each Alarm
class AlarmItem {
  int id;
  String title;
  String time;
  List<bool> dowState;
  bool activate;
  AlarmItem(
      {required this.id,
      this.title = 'Alarm',
      List<bool>? dowState,
      this.activate = true,
      String time = ""})
      // if dowState is null set dowState to a default list
      : dowState = dowState ?? [false, true, true, true, true, true, false],
        // if time is empty set the current time to the time variable with formatter
        time = time == "" ? dateFormatter.format(DateTime.now()) : time;

  // Convert List Of dowState To A String
  String dowStateToString() {
    String tmp = '';
    for (int i = 0; i <= 6; i++) {
      tmp += this.dowState[i] ? '1' : '0';
    }
    return tmp;
  }

  // Convert String To A List Of Boolean
  static List<bool> getDowState(String str) {
    List<bool> tmp = [];
    for (int i = 0; i <= 6; i++) {
      tmp.add(str[i] == '1' ? true : false);
    }
    return tmp;
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
