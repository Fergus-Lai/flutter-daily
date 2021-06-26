import 'package:flutter/material.dart';

const Color backgroundColor = Color(0xFF000000);
const Color activeTextColor = Color(0xFFFFFFFF);
const Color activeButtonColor = Color(0xFF8E24AA);
const Color inactiveColor = Color(0xFF757575);
const Color warningColor = Color(0xFFB71C1C);
const Color safeColor = Color(0xFF1B5E20);
const Color editColor = Color(0xFF01579B);
Color helperColor(bool x) {
  if (x) {
    return warningColor;
  }
  return inactiveColor;
}

const double helperSize = 15;
const double titleSize = 30;

const TextStyle titleTextStyle =
    TextStyle(color: activeTextColor, fontSize: titleSize);
const TextStyle activeTextStyle =
    TextStyle(color: activeTextColor, fontSize: 20);
const TextStyle inactiveTextStyle =
    TextStyle(color: inactiveColor, fontSize: 20);

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
    color: activeTextColor,
    height: 5,
    thickness: 2,
  );
}
