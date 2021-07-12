import 'package:flutter/material.dart';

const Color backgroundColor = Color(0xFF000000);
const Color activeTextColor = Color(0xFFFFFFFF);
const Color activeButtonColor = Color(0xFF8E24AA);
const Color inactiveColor = Color(0xFF757575);
const Color warningColor = Color(0xFFB71C1C);
const Color safeColor = Color(0xFF1B5E20);
const Color editColor = Color(0xFF01579B);
const Color dialogColor = Color(0xFF424242);
Color helperColor(bool x) {
  if (x) {
    return warningColor;
  }
  return inactiveColor;
}

List<Color> scheduleColor = [
  Color(0xFFE91E63),
  Color(0xFFC2185B),
  Color(0xFF880E4F),
  Color(0xFFF44336),
  Color(0xFFD32F2F),
  Color(0xFFB71C1C),
  Color(0xFFFF5722),
  Color(0xFFE64A19),
  Color(0xFFBF360C),
  Color(0xFFFFB74D),
  Color(0xFFFF9800),
  Color(0xFFF57C00),
  Color(0xFFFFF176),
  Color(0xFFFFEB3B),
  Color(0xFFFBC02D),
  Color(0xFF81C784),
  Color(0xFF4CAF50),
  Color(0xFF388E3C),
  Color(0xFF4DB6AC),
  Color(0xFF26A96A),
  Color(0xFF00796B),
  Color(0xFF4DD0E1),
  Color(0xFF00BCD4),
  Color(0xFF0097A7),
  Color(0xFF64B5F6),
  Color(0xFF2196F3),
  Color(0xFF1976D2),
  Color(0xFFBA68C8),
  Color(0xFF9C27B0),
  Color(0xFF7B1FA2),
];

const double helperSize = 15;
const double textSize = 20;
const double titleSize = 30;

const TextStyle titleTextStyle =
    TextStyle(color: activeTextColor, fontSize: titleSize);
const TextStyle activeTextStyle =
    TextStyle(color: activeTextColor, fontSize: textSize);
const TextStyle inactiveTextStyle =
    TextStyle(color: inactiveColor, fontSize: textSize);

Widget roundedSquareButton(void Function() onPressHandler, String text) {
  return SizedBox(
      width: 250,
      child: ElevatedButton(
          onPressed: onPressHandler,
          style: ElevatedButton.styleFrom(
            primary: activeButtonColor,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30.0),
            ),
          ),
          child: Text(
            text,
            style: TextStyle(fontSize: 20, color: Colors.white),
          )));
}

Widget divider() {
  return Divider(
    color: inactiveColor,
    height: 5,
    thickness: 2,
  );
}
