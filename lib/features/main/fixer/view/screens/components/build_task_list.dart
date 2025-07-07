import 'package:flutter/material.dart';
import 'package:quick_pitch_app/core/config/responsive.dart';
import 'package:quick_pitch_app/features/main/fixer/view/screens/components/task_card.dart';

class BuildTaskList extends StatelessWidget {
  const BuildTaskList({
    super.key,
    required this.res,
    required this.newTasks,
  });

  final Responsive res;
  final List newTasks;

  @override
  Widget build(BuildContext context) {
    if (newTasks.isEmpty) {
      return Center(
        child: Text(
          "No new tasks found.",
          style: TextStyle(fontSize: res.sp(14), color: Colors.grey[600]),
        ),
      );
    }

    return Column(
      children: newTasks.map((task) {
        return TaskCard(
          title: task.title,
          location: task.location,
          budget: task.budget,
          imageUrls: task.imagesUrl,
          onTap: () {
            // Navigate to task detail
          },
        );
      }).toList(),
    );
  }
}
