import 'package:flutter/material.dart';
import 'package:quick_pitch_app/core/config/responsive.dart';

class FixerHomeEmptyState extends StatelessWidget {
  const FixerHomeEmptyState({
    super.key,
    required this.res,
    required this.title,
    required this.subtitle,
    required this.icon,
  });

  final Responsive res;
  final String title;
  final String subtitle;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(res.wp(8)),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.9),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: Column(
        children: [
          Icon(
            icon,
            size: res.sp(48),
            color: const Color(0xFF94A3B8),
          ),
          SizedBox(height: res.hp(2)),
          Text(
            title,
            style: TextStyle(
              fontSize: res.sp(16),
              fontWeight: FontWeight.w600,
              color: const Color(0xFF475569),
            ),
          ),
          SizedBox(height: res.hp(0.5)),
          Text(
            subtitle,
            style: TextStyle(
              fontSize: res.sp(12),
              color: const Color(0xFF64748B),
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
