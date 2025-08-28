import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quick_pitch_app/core/config/responsive.dart';
import 'package:quick_pitch_app/features/poster_task/model/task_post_model.dart';
import 'package:quick_pitch_app/features/profile_completion/model/user_profile_model.dart';
import 'package:quick_pitch_app/features/requests/poster/view/components/pitch_tab_section/avatar_container.dart';
import 'package:quick_pitch_app/features/requests/poster/view/components/pitch_tab_section/dialog_helper.dart';
import 'package:quick_pitch_app/features/requests/poster/viewmodel/cubit/pitches_state.dart';
import 'package:quick_pitch_app/features/task_pitching/model/pitch_model.dart';

class FixerListItem extends StatelessWidget {
  final String fixerId;
  final List<PitchModel> pitches;
  final TaskPostModel task;

  const FixerListItem({super.key, 
    required this.fixerId,
    required this.pitches,
    required this.task,
  });

  @override
  Widget build(BuildContext context) {
    final res = Responsive(context);

    return FutureBuilder<UserProfileModel?>(
      future: context.read<PitchesCubit>().getFixerDetails(fixerId),
      builder: (context, snapshot) {
        final fixer = snapshot.data;
        return Card(
          margin: EdgeInsets.symmetric(vertical: res.hp(0.5)),
          child: ListTile(
            leading: AvatarContainer(
              fixer: fixer,
              size: res.wp(10),
            ),
            title: Text(fixer?.name ?? "Unknown Fixer"),
            subtitle: Text(
              '${pitches.length} ${pitches.length == 1 ? 'pitch' : 'pitches'} • \$${pitches.first.budget}',
            ),
            onTap: () {
              Navigator.pop(context);
              DialogHelper.showFixerPitchesDialog(
                context,
                fixer: fixer,
                pitches: pitches,
                task: task,
              );
            },
          ),
        );
      },
    );
  }
}