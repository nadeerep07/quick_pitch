import 'package:flutter/material.dart';
import 'package:quick_pitch_app/features/poster_task/model/task_post_model.dart';
import 'package:quick_pitch_app/features/profile_completion/model/user_profile_model.dart';
import 'package:quick_pitch_app/features/requests/poster/view/components/all_fixers_dialog.dart';
import 'package:quick_pitch_app/features/requests/poster/view/components/fixer_pitches_dialog.dart';
import 'package:quick_pitch_app/features/task_pitching/model/pitch_model.dart';

class DialogHelper {
  static void showFixerPitchesDialog(
    BuildContext context, {
    required UserProfileModel? fixer,
    required List<PitchModel> pitches,
    required TaskPostModel task,
  }) {
    showDialog(
      context: context,
      builder: (context) => FixerPitchesDialog(
        fixer: fixer,
        pitches: pitches,
        task: task,
      ),
    );
  }

  static void showAllFixersDialog(
    BuildContext context, {
    required Map<String, List<PitchModel>> fixerPitches,
    required TaskPostModel task,
  }) {
    showDialog(
      context: context,
      builder: (context) => AllFixersDialog(
        fixerPitches: fixerPitches,
        task: task,
      ),
    );
  }
}
