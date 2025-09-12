import 'package:flutter/material.dart';
import 'package:quick_pitch_app/core/config/responsive.dart';

class PolicySection extends StatelessWidget {
  final Responsive res;
  final String title;
  final String content;

  const PolicySection({super.key, 
    required this.res,
    required this.title,
    required this.content,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(res.wp(4)),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(res.wp(3)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha:0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: res.sp(16),
              fontWeight: FontWeight.bold,
              color: const Color(0xFF1F2937),
            ),
          ),
          SizedBox(height: res.hp(1)),
          Text(
            content,
            style: TextStyle(
              fontSize: res.sp(14),
              fontWeight: FontWeight.w400,
              color: const Color(0xFF6B7280),
              height: 1.6,
            ),
          ),
        ],
      ),
    );
  }
}
