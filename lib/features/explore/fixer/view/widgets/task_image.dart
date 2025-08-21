import 'package:flutter/material.dart';
import 'package:quick_pitch_app/core/config/responsive.dart';
import 'package:quick_pitch_app/features/explore/fixer/view/widgets/budget_tag.dart';
import 'package:quick_pitch_app/features/poster_task/model/task_post_model.dart';

class TaskImage extends StatelessWidget {
  final TaskPostModel task;
  final Responsive responsive;
  final Color accentColor;

  const TaskImage({super.key, 
    required this.task,
    required this.responsive,
    required this.accentColor,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
      child: Container(
        height: responsive.hp(15),
        color: accentColor.withValues(alpha: 0.1),
        child: Stack(
          fit: StackFit.expand,
          children: [
            if (task.imagesUrl?.isNotEmpty ?? false)
              FadeInImage.assetNetwork(
                placeholder: 'assets/images/image_placeholder.png',
                image: task.imagesUrl!.first,
                fit: BoxFit.cover,
                imageErrorBuilder: (_, __, ___) =>
                    Image.asset('assets/images/image_placeholder.png'),
              )
            else
              Image.asset('assets/images/image_placeholder.png'),
            Positioned(
              bottom: 8,
              right: 8,
              child: BudgetTag(budget: task.budget),
            ),
          ],
        ),
      ),
    );
  }
}