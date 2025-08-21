import 'package:flutter/material.dart';
import 'package:quick_pitch_app/core/config/responsive.dart';

class HandleBar extends StatelessWidget {
  final Responsive res;
  const HandleBar({super.key, required this.res});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: res.wp(12),
        height: res.hp(0.5),
        decoration: BoxDecoration(
          color: Colors.grey[300],
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
  }
}
