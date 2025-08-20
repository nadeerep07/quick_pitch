import 'package:flutter/material.dart';
import 'package:quick_pitch_app/features/explore/fixer/view/components/tasks_grid.dart';
import 'package:quick_pitch_app/features/explore/fixer/view/widgets/skill_chip.dart';
import 'package:quick_pitch_app/features/poster_task/model/task_post_model.dart';

class SkillsRow extends StatelessWidget {
  final TaskPostModel task;
  final int extraSkillsCount;

  const SkillsRow({super.key, required this.task, required this.extraSkillsCount});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          ...task.skills.take(2).map(
            (skill) => SkillChip(label: skill, theme: theme),
          ),
          if (extraSkillsCount > 0)
            SkillChip(label: '+$extraSkillsCount more', theme: theme, isExtra: true),
        ],
      ),
    );
  }
}
