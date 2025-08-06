import 'package:flutter/material.dart';
import 'package:quick_pitch_app/core/common/app_button.dart';
import 'package:quick_pitch_app/features/poster_task/repository/task_post_repository.dart';
import 'package:quick_pitch_app/features/task_pitching/model/pitch_model.dart';
import 'package:quick_pitch_app/features/task_pitching/view/screen/task_pitching_screen.dart';

class FixerPitchDetailRepitchButton extends StatelessWidget {
  const FixerPitchDetailRepitchButton({
    super.key,
    required this.context,
    required this.theme,
    required this.colorScheme,
    required this.currentPitch,
  });

  final BuildContext context;
  final ThemeData theme;
  final ColorScheme colorScheme;
  final PitchModel currentPitch;

  @override
  Widget build(BuildContext context) {
  return SizedBox(
    width: double.infinity,
    child: AppButton(
      text: 'Create New Pitch',
      onPressed: () async {
        // Navigate to pitch creation screen
        final task = await TaskPostRepository().fetchTaskById(currentPitch.taskId);
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => TaskPitchingScreen(taskData: task!),
          ),
        );
      },
    ),
  );
}
}
