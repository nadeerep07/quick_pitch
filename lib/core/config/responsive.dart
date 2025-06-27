import 'package:flutter/material.dart';

class Responsive {
  final BuildContext context;
  final Size size;
  final TextScaler textScaler;

  Responsive(this.context)
      : size = MediaQuery.of(context).size,
        textScaler = MediaQuery.of(context).textScaler;

  double wp(double percent) => size.width * percent / 100;
  double hp(double percent) => size.height * percent / 100;

  double sp(double fontSize) => textScaler.scale(fontSize);

  double get width => size.width;
  double get height => size.height;
}
