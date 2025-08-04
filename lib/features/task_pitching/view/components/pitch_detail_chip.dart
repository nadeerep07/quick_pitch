import 'package:flutter/material.dart';
import 'package:quick_pitch_app/core/config/responsive.dart';

class DetailChip extends StatelessWidget {
  final IconData icon;
  final String text;
  final Color color;
  final Responsive res;

  const DetailChip({super.key, 
    required this.icon,
    required this.text,
    required this.color,
    required this.res,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: res.hp(0.8), horizontal: res.wp(2.5)),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(res.wp(5)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: res.wp(3.5), color: color),
          SizedBox(width: res.wp(1)),
          Text(
            text,
            style: TextStyle(
              fontSize: res.sp(12),
              fontWeight: FontWeight.w500,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}