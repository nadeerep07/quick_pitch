import 'package:flutter/material.dart';
import 'package:quick_pitch_app/core/config/responsive.dart';
import 'package:quick_pitch_app/features/explore/fixer/view/components/tasks_grid.dart';
import 'package:quick_pitch_app/features/explore/fixer/view/widgets/task_image.dart';
import 'package:quick_pitch_app/features/explore/fixer/view/widgets/task_info.dart';
import 'package:quick_pitch_app/features/poster_task/model/task_post_model.dart';
import 'package:quick_pitch_app/features/task_detail/fixer/view/screen/fixer_side_detail_screen.dart';

class TaskCard extends StatelessWidget {
  final TaskPostModel task;
  final int index;
  final Responsive responsive;

  const TaskCard({
    super.key,
    required this.task,
    required this.index,
    required this.responsive,
  });

  @override
  Widget build(BuildContext context) {
    final accentColor = _getColorForIndex(index);

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 4.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withValues(alpha: 0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => FixerSideDetailScreen(task: task),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TaskImage(task: task, responsive: responsive, accentColor: accentColor),
            TaskInfo(task: task, responsive: responsive),
          ],
        ),
      ),
    );
  }

  Color _getColorForIndex(int index) {
    const colors = [
      Color(0xFF4E5AF2),
      Color(0xFF6C5CE7),
      Color(0xFF00B894),
      Color(0xFFFD79A8),
      Color(0xFFFDCB6E),
    ];
    return colors[index % colors.length];
  }
}