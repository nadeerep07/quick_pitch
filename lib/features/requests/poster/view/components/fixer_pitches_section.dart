import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quick_pitch_app/core/config/responsive.dart';
import 'package:quick_pitch_app/features/poster_task/model/task_post_model.dart';
import 'package:quick_pitch_app/features/requests/poster/view/components/fixer_avatars_row.dart';
import 'package:quick_pitch_app/features/requests/poster/viewmodel/cubit/pitches_state.dart';
import 'package:quick_pitch_app/features/task_pitching/model/pitch_model.dart';

class FixerPitchesSection extends StatelessWidget {
  final Map<String, List<PitchModel>> fixerPitches;
  final TaskPostModel task;

  const FixerPitchesSection({
    super.key,
    required this.fixerPitches,
    required this.task,
  });

  @override
  Widget build(BuildContext context) {
    final res = Responsive(context);
    final filteredPitches = context.read<PitchesCubit>().getActiveFixerPitches(
      fixerPitches,
    );
    return Padding(
      padding: EdgeInsets.all(res.wp(4)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Fixers who pitched:',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: res.sp(14)),
          ),
          SizedBox(height: res.hp(1.5)),
          FixerAvatarsRow(fixerPitches: filteredPitches, task: task),
        ],
      ),
    );
  }
}
