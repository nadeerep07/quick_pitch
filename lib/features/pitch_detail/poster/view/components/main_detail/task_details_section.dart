import 'package:flutter/material.dart';
import 'package:quick_pitch_app/core/config/responsive.dart';
import 'package:quick_pitch_app/features/pitch_detail/poster/view/components/main_detail/detail_row.dart';
import 'package:quick_pitch_app/features/poster_task/model/task_post_model.dart';

/// Task Details Section
class TaskDetailsSection extends StatelessWidget {
  final TaskPostModel task;
  const TaskDetailsSection({super.key, required this.task});

  @override
  Widget build(BuildContext context) {
    final res = Responsive(context);
    final colorScheme = Theme.of(context).colorScheme;

    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(res.wp(4)),
      ),
      color: colorScheme.surface.withValues(alpha: 0.9),
      child: Padding(
        padding: EdgeInsets.all(res.wp(4)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Task Details',
              style: TextStyle(
                fontSize: res.sp(16),
                fontWeight: FontWeight.bold,
                color: colorScheme.primary,
              ),
            ),
            SizedBox(height: res.hp(1.5)),
            DetailRow(
              icon: Icons.title,
              label: 'Title',
              value: task.title,
            ),
            DetailRow(
              icon: Icons.description,
              label: 'Description',
              value: task.description,
            ),
            DetailRow(
              icon: Icons.attach_money,
              label: 'Budget',
              value: '₹${task.budget}',
            ),
          ],
        ),
      ),
    );
  }
}
