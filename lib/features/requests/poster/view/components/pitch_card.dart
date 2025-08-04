import 'package:flutter/material.dart';
import 'package:quick_pitch_app/core/config/responsive.dart';
import 'package:quick_pitch_app/features/Pitch_detail/poster/view/screen/Pitch_detail_screen.dart';
import 'package:quick_pitch_app/features/poster_task/model/task_post_model.dart';
import 'package:quick_pitch_app/features/task_pitching/model/pitch_model.dart';

class PitchCard extends StatelessWidget {
  final PitchModel pitch;
  final TaskPostModel task;

  const PitchCard({super.key, 
    required this.pitch,
    required this.task,
  });

  @override
  Widget build(BuildContext context) {
    final res = Responsive(context);

    return Card(
      margin: EdgeInsets.symmetric(vertical: res.hp(0.5)),
      child: ListTile(
        title: Text(pitch.pitchText),
        subtitle: Text(
          '${pitch.paymentType.name.toUpperCase()} • ₹${pitch.budget}',
        ),
        onTap: () {
          Navigator.pop(context);
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => PitchDetailScreen(pitch: pitch, task: task),
            ),
          );
        },
      ),
    );
  }
}
