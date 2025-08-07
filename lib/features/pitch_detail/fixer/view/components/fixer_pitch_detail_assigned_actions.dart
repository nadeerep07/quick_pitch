// File: fixer_pitch_detail_ui_helper.dart

import 'package:flutter/material.dart';
import 'package:quick_pitch_app/core/common/app_button.dart';
import 'package:quick_pitch_app/core/config/responsive.dart';
import 'package:quick_pitch_app/features/pitch_detail/fixer/view/components/papyemt_conformation_dialog.dart';
import 'package:quick_pitch_app/features/pitch_detail/fixer/view/components/update_dialog.dart';
import 'package:quick_pitch_app/features/task_pitching/model/pitch_model.dart';

class FixerPitchDetailAssignedActions extends StatelessWidget {
  const FixerPitchDetailAssignedActions({
    super.key,
    required this.context,
    required this.res,
    required this.currentPitch,
    required this.colorScheme,
    required this.theme,
  });

  final BuildContext context;
  final Responsive res;
  final PitchModel currentPitch;
  final ColorScheme colorScheme;
  final ThemeData theme;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          width: double.infinity,
          child: AppButton(
            text: 'Mark as Completed',
            onPressed: () => showCompletionDialog(context, res, currentPitch),
          ),
        ),
        SizedBox(height: res.hp(2)),
        SizedBox(
          width: double.infinity,
          child: OutlinedButton(
            onPressed: () => showUpdateDialog(context, currentPitch, res),
            style: OutlinedButton.styleFrom(
              padding: EdgeInsets.symmetric(vertical: res.hp(2)),
              side: BorderSide(color: colorScheme.primary),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: Text(
              'Add Work Update',
              style: theme.textTheme.bodyLarge?.copyWith(
                color: colorScheme.primary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
      ],
    );
  }
}