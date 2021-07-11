import 'package:intl/intl.dart';

// Declaring DateFormatter and Time Foramtter With intl for date and time formatting
final DateFormat dateFormatter = DateFormat('yyyy-MM-dd');
final DateFormat timeFormatter = DateFormat('HH:mm');

class CalendarItem {
  int id;
  String title;
  String date;
  String time;

  CalendarItem(
      {required this.id, this.title = "Event", String? date, String? time})
      : date = date ?? dateToString(DateTime.now().add(Duration(days: 1))),
        time = time ?? timeToString(DateTime.now().add(Duration(days: 1)));

  DateTime getDateTime() {
    return DateTime(
        int.parse(date.split("-")[0]),
        int.parse(date.split("-")[1]),
        int.parse(date.split("-")[2]),
        int.parse(time.split(":")[0]),
        int.parse(time.split(":")[1]));
  }

  static String dateToString(DateTime dateTime) {
    return dateFormatter.format(DateTime.now().add(Duration(days: 1)));
  }

  static String timeToString(DateTime dateTime) {
    return timeFormatter.format(DateTime.now().add(Duration(days: 1)));
  }
}
