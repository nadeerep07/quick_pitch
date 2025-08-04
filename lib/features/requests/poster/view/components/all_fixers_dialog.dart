import 'package:flutter/material.dart';
import 'package:quick_pitch_app/core/config/responsive.dart';
import 'package:quick_pitch_app/features/poster_task/model/task_post_model.dart';
import 'package:quick_pitch_app/features/requests/poster/view/components/fixer_list_item.dart';
import 'package:quick_pitch_app/features/task_pitching/model/pitch_model.dart';

class AllFixersDialog extends StatelessWidget {
  final Map<String, List<PitchModel>> fixerPitches;
  final TaskPostModel task;

  const AllFixersDialog({super.key, 
    required this.fixerPitches,
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
      child: Padding(
        padding: EdgeInsets.all(res.wp(4)),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'All Fixers for ${task.title}',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: res.sp(16),
              ),
            ),
            SizedBox(height: res.hp(1)),
            ...fixerPitches.keys.map((fixerId) {
              final pitches = fixerPitches[fixerId]!;
              return FixerListItem(
                fixerId: fixerId,
                pitches: pitches,
                task: task,
              );
            }),
            SizedBox(height: res.hp(1)),
            Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text("Close"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
