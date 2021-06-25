import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';

final DateFormat dateFormatter = DateFormat('HH:mm');
var uuid = Uuid();

// Class For Storing Each Alarm
class AlarmItem {
  String id;
  String title;
  String time;
  List<bool> dowState;
  bool activate;
  AlarmItem(
      {String? id,
      this.title = 'Alarm',
      List<bool>? dowState,
      this.activate = true,
      String time = ""})
      : id = id ?? uuid.v1(),
        dowState = dowState ?? [false, true, true, true, true, true, false],
        time = time == "" ? dateFormatter.format(DateTime.now()) : time;

  String dowStateToString() {
    String tmp = '';
    for (int i = 0; i <= 6; i++) {
      tmp += this.dowState[i] ? '1' : '0';
    }
    return tmp;
  }

  static List<bool> getDowState(String str) {
    List<bool> tmp = [];
    for (int i = 0; i <= 6; i++) {
      tmp.add(str[i] == '1' ? true : false);
    }
    return tmp;
  }

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
      i++;
      if (dowState[i % 7]) {
        tmp = tmp.add(Duration(days: (i - now.weekday)));
        return tmp.difference(now).inMinutes;
      }
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
