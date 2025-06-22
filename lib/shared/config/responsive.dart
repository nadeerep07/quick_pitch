import 'package:flutter/material.dart';

class Responsive {
  final BuildContext context;
  final Size size;

  Responsive(this.context) : size = MediaQuery.of(context).size;

  double wp(double percent) => size.width * percent / 100;
  double hp(double percent) => size.height * percent / 100;

  double get width => size.width;
  double get height => size.height;
}
