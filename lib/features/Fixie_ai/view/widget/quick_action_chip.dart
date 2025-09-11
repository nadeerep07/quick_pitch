// lib/features/fixie_ai/view/fixie_ai_screen.dart

import 'package:flutter/material.dart';
import 'package:quick_pitch_app/core/config/responsive.dart';

class QuickActionChip extends StatelessWidget {
  final String label;
  final IconData icon;
  final Color color;
  final Responsive responsive;
  final VoidCallback onTap;

  const QuickActionChip({
    super.key,
    required this.label,
    required this.icon,
    required this.color,
    required this.responsive,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(right: responsive.wp(3)),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(responsive.wp(5)),
        child: Container(
          padding: EdgeInsets.symmetric(
            horizontal: responsive.wp(5),
            vertical: responsive.hp(1.5),
          ),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                color.withValues(alpha: 0.2),
                color.withValues(alpha: 0.1),
              ],
            ),
            borderRadius: BorderRadius.circular(responsive.wp(5)),
            border: Border.all(color: color.withValues(alpha: 0.3)),
            boxShadow: [
              BoxShadow(
                color: color.withValues(alpha: 0.2),
                blurRadius: responsive.wp(2),
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                icon,
                color: color,
                size: responsive.wp(4.5),
              ),
              SizedBox(width: responsive.wp(2)),
              Text(
                label,
                style: TextStyle(
                  color: color,
                  fontSize: responsive.sp(13),
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
