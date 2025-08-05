import 'package:flutter/material.dart';
import 'package:quick_pitch_app/core/config/responsive.dart';

class FixerHomeStateCard extends StatelessWidget {
  const FixerHomeStateCard({
    super.key,
    required this.res,
    required this.title,
    required this.count,
    required this.icon,
    required this.iconColor,
    required this.bgColor,
  });

  final Responsive res;
  final String title;
  final String count;
  final IconData icon;
  final Color iconColor;
  final Color bgColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(res.wp(4)),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.9),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE2E8F0)),
        boxShadow: const [
          BoxShadow(
            color: Color(0x08000000),
            blurRadius: 4,
            offset: Offset(0, 1),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: bgColor,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: iconColor, size: 20),
          ),
          SizedBox(height: res.hp(1)),
          Text(
            count,
            style: TextStyle(
              fontSize: res.sp(16),
              fontWeight: FontWeight.w700,
              color: const Color(0xFF1E293B),
            ),
          ),
          Text(
            title,
            style: TextStyle(
              fontSize: res.sp(11),
              color: const Color(0xFF64748B),
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
