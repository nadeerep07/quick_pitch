import 'package:flutter/material.dart';
import 'package:quick_pitch_app/core/config/responsive.dart';

class BuildSectionTitle extends StatelessWidget {
  const BuildSectionTitle({
    super.key,
    required this.res,
    required this.title,
    required this.trailing,
  });

  final Responsive res;
  final String title;
  final Widget trailing;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(title, style: TextStyle(fontSize: res.sp(18), fontWeight: FontWeight.bold)),
        IconButton(onPressed: () {}, icon: trailing),
      ],
    );
  }
}
