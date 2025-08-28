import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quick_pitch_app/core/config/responsive.dart';
import 'package:quick_pitch_app/features/poster_task/model/task_post_model.dart';
import 'package:quick_pitch_app/features/profile_completion/model/user_profile_model.dart';
import 'package:quick_pitch_app/features/requests_pitches/poster/view/components/pitch_tab_section/avatar_container.dart';
import 'package:quick_pitch_app/features/requests_pitches/poster/view/components/pitch_tab_section/dialog_helper.dart';
import 'package:quick_pitch_app/features/requests_pitches/poster/viewmodel/cubit/pitches_state.dart';
import 'package:quick_pitch_app/features/task_pitching/model/pitch_model.dart';

class FixerAvatar extends StatelessWidget {
  final String fixerId;
  final List<PitchModel> pitch;
  final TaskPostModel task;

  const FixerAvatar({super.key, 
    required this.fixerId,
    required this.pitch,
    required this.task,
  });

  @override
  Widget build(BuildContext context) {
    final res = Responsive(context);

    return FutureBuilder<UserProfileModel?>(
      future: context.read<PitchesCubit>().getFixerDetails(fixerId),
      builder: (context, snapshot) {
        final fixer = snapshot.data;
        return GestureDetector(
          onTap: () => DialogHelper.showFixerPitchesDialog(
            context,
            fixer: fixer,
            pitches: pitch,
            task: task,
          ),
          child: AvatarContainer(
            fixer: fixer,
            size: res.wp(12),
          ),
        );
      },
    );
  }
}
