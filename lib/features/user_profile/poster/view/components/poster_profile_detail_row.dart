import 'package:flutter/material.dart';
import 'package:quick_pitch_app/core/config/responsive.dart';

class PosterProfileDetailRow extends StatelessWidget {
  const PosterProfileDetailRow({
    super.key,
    required this.res,
    required this.icon,
    required this.text,
    required this.colorScheme,
  });

  final Responsive res;
  final IconData icon;
  final String text;
  final ColorScheme colorScheme;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: res.sp(18), color: colorScheme.primary),
        SizedBox(width: res.wp(3)),
        Expanded(
          child: Text(
            text,
            style: TextStyle(
              fontSize: res.sp(15),
              color: colorScheme.onSurface.withOpacity(0.8),
            ),
          ),
        ),
      ],
    );
  }
}
