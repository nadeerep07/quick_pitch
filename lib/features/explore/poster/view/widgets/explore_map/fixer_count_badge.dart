import 'package:flutter/material.dart';
import 'package:quick_pitch_app/core/config/responsive.dart';

class FixerCountBadge extends StatelessWidget {
  final int count;

  const FixerCountBadge({super.key, required this.count});

  @override
  Widget build(BuildContext context) {
    final res = Responsive(context);

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: res.wp(3),
        vertical: res.hp(1),
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.location_on, size: res.sp(16), color: Colors.blue),
          SizedBox(width: res.wp(1)),
          Text(
            '$count',
            style: TextStyle(
              fontSize: res.sp(14),
              fontWeight: FontWeight.bold,
              color: Colors.blue,
            ),
          ),
        ],
      ),
    );
  }
}
