import 'package:flutter/material.dart';
import 'package:quick_pitch_app/core/config/responsive.dart';
import 'package:quick_pitch_app/features/poster_task/model/task_post_model.dart';
import 'package:quick_pitch_app/features/requests/poster/view/components/placeholder_content.dart';
import 'package:quick_pitch_app/features/requests/poster/view/components/task_pitch_card.dart';
import 'package:quick_pitch_app/features/task_pitching/model/pitch_model.dart';

class PitchesContent extends StatelessWidget {
  final List<Map<String, dynamic>> groupedPitches;

  const PitchesContent({super.key, required this.groupedPitches});

  @override
  Widget build(BuildContext context) {
    final res = Responsive(context);

    if (groupedPitches.isEmpty) {
      return const PlaceholderContent(message: "No pitches received yet");
    }

    return Padding(
      padding: EdgeInsets.all(res.wp(4)),
      child: ListView.builder(
        itemCount: groupedPitches.length,
        itemBuilder: (context, index) {
          final task = groupedPitches[index]['task'] as TaskPostModel;
          final pitches = groupedPitches[index]['pitches'] as List<PitchModel>;
          
          return TaskPitchCard(
            task: task,
            pitches: pitches,
          );
        },
      ),
    );
  }
}
