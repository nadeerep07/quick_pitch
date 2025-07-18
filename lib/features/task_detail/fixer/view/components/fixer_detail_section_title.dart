import 'package:flutter/material.dart';
import 'package:quick_pitch_app/core/config/responsive.dart';

class FixerDetailSectionTitle extends StatelessWidget {
  const FixerDetailSectionTitle({
    super.key,
    required this.title,
    required this.icon,
    required this.res,
  });

  final String title;
  final IconData icon;
  final Responsive res;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: res.sp(16), color: Colors.black),
        SizedBox(width: res.wp(1.5)),
        Text(title, style: TextStyle(fontSize: res.sp(14), fontWeight: FontWeight.bold)),
      ],
    );
  }
}