import 'package:flutter/material.dart';
import 'package:quick_pitch_app/features/pitch_detail/poster/view/screen/pitch_assigned_detail_screen.dart';
import 'package:quick_pitch_app/features/poster_task/model/task_post_model.dart';
import 'package:quick_pitch_app/features/requests/poster/view/components/asiggned_tab_sections/assigned_fixer_section.dart';
import 'package:quick_pitch_app/features/requests/poster/view/components/asiggned_tab_sections/task_description.dart';
import 'package:quick_pitch_app/features/requests/poster/view/components/asiggned_tab_sections/task_header.dart';

class AssignedTaskCard extends StatelessWidget {
  final TaskPostModel task;
  final List pitches;

  const AssignedTaskCard({super.key, required this.task, required this.pitches});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (pitches.isNotEmpty) {
          final pitchId = pitches.first.id;
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => PitchAssignedDetailScreen(task: task, pitchId: pitchId),
            ),
          );
        }
      },
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TaskHeader(task: task),
              const SizedBox(height: 16),
              TaskDescription(task: task),
              const SizedBox(height: 16),
              if (task.assignedFixerName != null)
                AssignedFixerSection(task: task),
            ],
          ),
        ),
      ),
    );
  }
}
