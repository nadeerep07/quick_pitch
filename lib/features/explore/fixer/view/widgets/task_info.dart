import 'package:flutter/material.dart';
import 'package:quick_pitch_app/core/config/responsive.dart';
import 'package:quick_pitch_app/features/explore/fixer/view/components/tasks_grid.dart';
import 'package:quick_pitch_app/features/explore/fixer/view/widgets/skills_row.dart';
import 'package:quick_pitch_app/features/poster_task/model/task_post_model.dart';

class TaskInfo extends StatelessWidget {
  final TaskPostModel task;
  final Responsive responsive;

  const TaskInfo({super.key, required this.task, required this.responsive});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final maxSkillsToShow = 2;
    final extraSkillsCount = task.skills.length - maxSkillsToShow;

    return Padding(
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            task.title,
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w700,
              color: Colors.black87,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          SizedBox(height: responsive.hp(1)),
          SkillsRow(task: task, extraSkillsCount: extraSkillsCount),
          SizedBox(height: responsive.hp(1)),
          Row(
            children: [
              Icon(Icons.location_on_outlined, size: 16, color: Colors.grey.shade600),
              SizedBox(width: responsive.wp(2)),
              Expanded(
                child: Text(
                  task.location,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: Colors.grey.shade700,
                    fontWeight: FontWeight.w500,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}