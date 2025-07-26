import 'package:flutter/material.dart';
import 'package:quick_pitch_app/core/config/responsive.dart';

class PosterProfileDivider extends StatelessWidget {
  const PosterProfileDivider({
    super.key,
    required this.res,
    required this.colorScheme,
  });

  final Responsive res;
  final ColorScheme colorScheme;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: res.hp(6),
      width: 1,
      color: colorScheme.outline.withOpacity(0.2),
    );
  }
}