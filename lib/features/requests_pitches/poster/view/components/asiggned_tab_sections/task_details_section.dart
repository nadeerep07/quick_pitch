import 'package:flutter/material.dart';
import 'package:quick_pitch_app/core/common/date_formatter.dart';
import 'package:quick_pitch_app/features/poster_task/model/task_post_model.dart';

class TaskDetailsSection extends StatelessWidget {
  final TaskPostModel task;

  const TaskDetailsSection({super.key, required this.task});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.blue.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Icon(Icons.assignment, size: 18, color: Colors.blue[600]),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Task Details',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: Colors.blue[700],
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Priority: ${task.priority} • Due: ${DateFormatter.format(task.deadline)}',
                  style: TextStyle(fontSize: 12, color: Colors.blue[600]),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
