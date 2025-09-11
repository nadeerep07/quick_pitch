import 'package:flutter/material.dart';
import 'package:quick_pitch_app/core/config/responsive.dart';

class ChipTag extends StatelessWidget {
  final String text;
  final Responsive res;
  final Color bg;
  final Color fg;
  final ThemeData theme;

  const ChipTag({
    required this.text,
    required this.res,
    required this.bg,
    required this.fg,
    required this.theme,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: res.wp(2), vertical: res.wp(1)),
      decoration: BoxDecoration(color: bg, borderRadius: BorderRadius.circular(6)),
      child: Text(
        text,
        style: theme.textTheme.labelSmall?.copyWith(
          color: fg,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
