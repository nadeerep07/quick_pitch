// File: fixer_pitch_detail_ui_helper.dart

import 'package:flutter/material.dart';
import 'package:quick_pitch_app/core/config/responsive.dart';
import 'package:quick_pitch_app/features/pitch_detail/fixer/view/components/fixer_pitch_detail_item.dart';

class FixerPitchBuildItem extends StatelessWidget {
  const FixerPitchBuildItem({
    super.key,
    required this.res,
    required this.theme,
    required this.colorScheme,
    required this.icon,
    required this.label,
    required this.value,
  });

  final Responsive res;
  final ThemeData theme;
  final ColorScheme colorScheme;
  final IconData icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        FixerPitchDetailItem(
          res: res,
          icon: icon,
          label: label,
          value: value,
          theme: theme,
          colorScheme: colorScheme,
        ),
        SizedBox(height: res.hp(2)),
      ],
    );
  }
}
