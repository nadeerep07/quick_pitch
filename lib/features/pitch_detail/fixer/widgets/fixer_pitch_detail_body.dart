import 'package:flutter/material.dart';
import 'package:quick_pitch_app/core/config/responsive.dart';
import 'package:quick_pitch_app/features/pitch_detail/fixer/view/components/fixer_pitch_detail_assigned_actions.dart';
import 'package:quick_pitch_app/features/pitch_detail/fixer/view/components/fixer_pitch_detail_completion_section.dart';
import 'package:quick_pitch_app/features/pitch_detail/fixer/view/components/fixer_pitch_detail_header_card.dart';
import 'package:quick_pitch_app/features/pitch_detail/fixer/view/components/fixer_pitch_detail_progress_section.dart';
import 'package:quick_pitch_app/features/pitch_detail/fixer/view/components/fixer_pitch_detail_rejection_card.dart';
import 'package:quick_pitch_app/features/pitch_detail/fixer/view/components/fixer_pitch_detail_repitch_button.dart';
import 'package:quick_pitch_app/features/pitch_detail/fixer/view/components/fixer_pitch_detail_task_card.dart';
import 'package:quick_pitch_app/features/task_pitching/model/pitch_model.dart';
import 'package:quick_pitch_app/features/poster_task/model/task_post_model.dart';
import 'package:quick_pitch_app/features/pitch_detail/fixer/viewmodel/cubit/fixer_pitch_detail_cubit.dart';
import 'package:quick_pitch_app/features/pitch_detail/fixer/view/components/fixer_pitch_processing_overlay.dart';

Widget buildPitchDetailBody({
  required BuildContext context,
  required Responsive res,
  required FixerPitchDetailState state,
  required PitchModel currentPitch,
  required TaskPostModel? currentTask,
  required ColorScheme colorScheme,
  required ThemeData theme,
  required bool isAssigned,
  required bool isCompleted,
  required bool isRejected,
  required VoidCallback onRequestPayment,
}) {
  return Stack(
    children: [
      SingleChildScrollView(
        padding: EdgeInsets.fromLTRB(
          res.wp(5),
          res.hp(12),
          res.wp(5),
          res.hp(4),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            FixerPitchHeaderCard(
              currentPitch: currentPitch,
              res: res,
              theme: theme,
              colorScheme: colorScheme,
              isAssigned: isAssigned,
              isCompleted: isCompleted,
            ),
            SizedBox(height: res.hp(2)),
            if (isCompleted)
              FixerPitchDetailCompletionSection(
                res: res,
                theme: theme,
                colorScheme: colorScheme,
                currentPitch: currentPitch,
              ),
            if (isRejected)
              FixerPitchDetailRejectionCard(
                res: res,
                theme: theme,
                colorScheme: colorScheme,
                currentPitch: currentPitch,
              ),
            FixerPitchDetailTaskCard(
              res: res,
              task: currentTask!, // Ensure non-null value
              theme: theme,
              colorScheme: colorScheme,
            ),
            if (isAssigned || isCompleted)
              FixerPitchDetailProgressSection(
                res: res,
                context: context,
                theme: theme,
                colorScheme: colorScheme,
                currentPitch: currentPitch,
              ),
            SizedBox(height: res.hp(2)),
            if (isRejected)
              FixerPitchDetailRepitchButton(
                context: context,
                theme: theme,
                colorScheme: colorScheme,
                currentPitch: currentPitch,
              ),
            if (isAssigned)
              FixerPitchDetailAssignedActions(
                context: context,
                res: res,
                currentPitch: currentPitch,
                colorScheme: colorScheme,
                theme: theme,
              ),
            SizedBox(height: res.hp(2)),
          ],
        ),
      ),
      if (state is FixerPitchDetailProcessing)
        FixerPitchProcessingOverlay(
          colorScheme: colorScheme,
          theme: theme,
          message: (state).message,
        ),
    ],
  );
}
