import 'package:flutter/material.dart';
import 'package:quick_pitch_app/features/poster_task/model/task_post_model.dart';
import 'package:quick_pitch_app/features/requests/poster/view/components/completed_tab_sections/fixer_section.dart';
import 'package:quick_pitch_app/features/requests/poster/view/components/completed_tab_sections/header.dart';
import 'package:quick_pitch_app/features/requests/poster/view/components/completed_tab_sections/task_title.dart';
import 'package:quick_pitch_app/features/task_pitching/model/pitch_model.dart';

/// --------------------
///  Completed Task Card
/// --------------------
class CompletedTaskCard extends StatelessWidget {
  final TaskPostModel task;
  final List<PitchModel> pitches;

  const CompletedTaskCard({super.key, required this.task, required this.pitches});

  @override
  Widget build(BuildContext context) {
    final acceptedPitch = pitches.firstWhere(
      (p) => p.status == 'accepted' || p.status == 'completed',
      orElse: () => pitches.first,
    );

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: _cardDecoration(),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Header(acceptedPitch: acceptedPitch),
          const SizedBox(height: 16),
          TaskTitle(title: task.title),
          const SizedBox(height: 12),
          FixerSection(task: task, acceptedPitch: acceptedPitch),
        ]),
      ),
    );
  }

  BoxDecoration _cardDecoration() => BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.green.withOpacity(0.1), width: 1),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 8,
              offset: const Offset(0, 2)),
        ],
      );
}

