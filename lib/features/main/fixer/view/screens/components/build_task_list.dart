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
      String getTimeAgo(DateTime dateTime) {
  final now = DateTime.now();
  final diff = now.difference(dateTime);

  if (diff.inMinutes < 60) return '${diff.inMinutes} minutes';
  if (diff.inHours < 24) return '${diff.inHours} hours';
  return '${diff.inDays} days';
}

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
          postedTime: getTimeAgo(task.createdAt),
          // priceType: task.priceType,
          // experienceLevel: task.experienceLevel,
          description: task.description,
          skills: task.skills,
          onTap: () {
            // Navigate to task detail
          },
        );
      }).toList(),
    );
  }
}
