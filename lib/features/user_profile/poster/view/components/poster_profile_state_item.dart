import 'package:flutter/material.dart';
import 'package:quick_pitch_app/core/config/responsive.dart';

class PosterProfileStateItem extends StatelessWidget {
  const PosterProfileStateItem({
    super.key,
    required this.res,
    required this.label,
    required this.value,
    required this.icon,
    required this.colorScheme,
  });

  final Responsive res;
  final String label;
  final String value;
  final IconData icon;
  final ColorScheme colorScheme;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: EdgeInsets.all(res.wp(3)),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: colorScheme.primary.withValues(alpha: 0.1),
          ),
          child: Icon(icon, size: res.sp(18), color: colorScheme.primary),
        ),
        SizedBox(height: res.hp(1)),
        Text(
          value,
          style: TextStyle(
            fontSize: res.sp(18),
            fontWeight: FontWeight.bold,
            color: colorScheme.primary,
          ),
        ),
        SizedBox(height: res.hp(0.5)),
        Text(
          label,
          style: TextStyle(
            fontSize: res.sp(12),
            color: colorScheme.onSurface.withValues(alpha: 0.6),
          ),
        ),
      ],
    );
  }
}
