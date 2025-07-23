import 'package:flutter/material.dart';

class CustomTextStyle {
  static TextStyle boldText(double fontSize, {Color color = Colors.black}) {
    return TextStyle(
      fontSize: fontSize,
      fontWeight: FontWeight.bold,
      color: color,
    );
  }

  static TextStyle mediumText(double fontSize, {Color color = Colors.black87}) {
    return TextStyle(
      fontSize: fontSize,
      fontWeight: FontWeight.w500,
      color: color,
    );
  }

  static TextStyle regularText(double fontSize, {Color color = Colors.black87}) {
    return TextStyle(
      fontSize: fontSize,
      fontWeight: FontWeight.normal,
      color: color,
    );
  }

  static TextStyle lightText(double fontSize, {Color color = Colors.black54}) {
    return TextStyle(
      fontSize: fontSize,
      fontWeight: FontWeight.w300,
      color: color,
    );
  }
}
