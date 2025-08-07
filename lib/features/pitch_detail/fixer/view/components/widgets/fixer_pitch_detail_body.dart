import 'package:flutter/material.dart';
import 'package:quick_pitch_app/core/config/responsive.dart';
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
            // Include your widgets here, like:
            // FixerPitchHeaderCard(...)
            // FixerPitchDetailTaskCard(...)
            // etc.
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
