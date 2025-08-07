import 'package:flutter/material.dart';
import 'package:quick_pitch_app/core/config/responsive.dart';

class FixerPitchDetailUiHelperPayementStatus extends StatelessWidget {
  const FixerPitchDetailUiHelperPayementStatus({
    super.key,
    required this.res,
    required this.theme,
    required this.label,
    required this.color,
  });

  final Responsive res;
  final ThemeData theme;
  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: OutlinedButton(
        onPressed: null,
        style: OutlinedButton.styleFrom(
          padding: EdgeInsets.symmetric(vertical: res.hp(2)),
          side: BorderSide(color: color),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
        child: Text(label, style: theme.textTheme.bodyLarge?.copyWith(color: color, fontWeight: FontWeight.w600)),
      ),
    );
  }
}