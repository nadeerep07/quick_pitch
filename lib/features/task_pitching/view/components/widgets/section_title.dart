import 'package:flutter/material.dart';
import 'package:quick_pitch_app/core/config/responsive.dart';

class SectionTitle extends StatelessWidget {
  const SectionTitle({
    super.key,
    required this.context,
    required this.title,
    required this.res,
    required this.colorScheme,
  });

  final BuildContext context;
  final String title;
  final Responsive res;
  final ColorScheme colorScheme;

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: Theme.of(context).textTheme.labelLarge?.copyWith(
        fontSize: res.sp(12),
        fontWeight: FontWeight.bold,
        color: colorScheme.onSurface.withValues(alpha: 0.6),
        letterSpacing: 1.2,
      ),
    );
  }
}
