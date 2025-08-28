import 'package:flutter/material.dart';
import 'package:quick_pitch_app/core/config/responsive.dart';
import 'package:quick_pitch_app/features/poster_task/model/task_post_model.dart';
import 'package:quick_pitch_app/features/requests/poster/view/components/pitch_tab_section/fixer_pitches_section.dart';
import 'package:quick_pitch_app/features/requests/poster/view/components/pitch_tab_section/pitch_helper.dart';
import 'package:quick_pitch_app/features/task_pitching/model/pitch_model.dart';

class TaskPitchCard extends StatelessWidget {
  final TaskPostModel task;
  final List<PitchModel> pitches;

  const TaskPitchCard({super.key, 
    required this.task,
    required this.pitches,
  });

  @override
  Widget build(BuildContext context) {
    final res = Responsive(context);
    final colorScheme = Theme.of(context).colorScheme;
    final fixerPitches = PitchHelper.groupPitchesByFixer(pitches);

    return Card(
      margin: EdgeInsets.symmetric(vertical: res.hp(1.5)),
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(res.wp(4)),
      ),
      color: colorScheme.surface.withValues(alpha: .9),
      child: ExpansionTile(
        title: Text(
          task.title,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: res.sp(16),
          ),
        ),
        subtitle: Text(
          task.description,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(fontSize: res.sp(12)),
        ),
        children: [
          FixerPitchesSection(
            fixerPitches: fixerPitches,
            task: task,
          ),
        ],
      ),
    );
  }
}
