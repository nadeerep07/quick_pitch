import 'package:flutter/material.dart';
import 'package:quick_pitch_app/core/config/app_colors.dart';
import 'package:quick_pitch_app/core/config/responsive.dart';
import 'package:quick_pitch_app/features/poster_task/model/task_post_model.dart';
import 'package:quick_pitch_app/features/profile_completion/model/user_profile_model.dart';
import 'package:quick_pitch_app/features/requests_pitches/poster/view/components/pitch_tab_section/avatar_container.dart';
import 'package:quick_pitch_app/features/requests_pitches/poster/view/components/pitch_tab_section/pitch_card.dart';
import 'package:quick_pitch_app/features/task_pitching/model/pitch_model.dart';

class FixerPitchesDialog extends StatelessWidget {
  final UserProfileModel? fixer;
  final List<PitchModel> pitches;
  final TaskPostModel task;

  const FixerPitchesDialog({super.key, 
    required this.fixer,
    required this.pitches,
    required this.task,
  });

  @override
  Widget build(BuildContext context) {
    final res = Responsive(context);
    final colorScheme = Theme.of(context).colorScheme;

    return Dialog(
      backgroundColor: colorScheme.surface.withValues(alpha: .95),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(res.wp(4)),
      ),
      child: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(res.wp(4)),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildFixerHeader(res),
              SizedBox(height: res.hp(2)),
              _buildPitchesSection(res, colorScheme),
              SizedBox(height: res.hp(1)),
              _buildCloseButton(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFixerHeader(Responsive res) {
    return Row(
      children: [
        AvatarContainer(
          fixer: fixer,
          size: res.wp(12),
        ),
        SizedBox(width: res.wp(4)),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                fixer?.name ?? "Unknown Fixer",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: res.sp(16),
                ),
              ),
              if (fixer?.fixerData?.skills != null &&
                  fixer!.fixerData!.skills!.isNotEmpty)
                Text(
                  fixer!.fixerData!.skills!.join(", "),
                  style: TextStyle(
                    fontSize: res.sp(12),
                    color: AppColors.primaryText,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildPitchesSection(Responsive res, ColorScheme colorScheme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Pitches for ${task.title}',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: res.sp(14),
          ),
        ),
        SizedBox(height: res.hp(1)),
        ...pitches.map((pitch) => PitchCard(
          pitch: pitch,
          task: task,
        )),
      ],
    );
  }

  Widget _buildCloseButton(BuildContext context) {
    return Align(
      alignment: Alignment.centerRight,
      child: TextButton(
        onPressed: () => Navigator.pop(context),
        child: const Text("Close"),
      ),
    );
  }
}
