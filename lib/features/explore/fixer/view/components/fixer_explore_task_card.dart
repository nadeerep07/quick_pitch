import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:quick_pitch_app/core/config/responsive.dart';
import 'package:quick_pitch_app/features/explore/fixer/view/components/fixer_explore_screen_task_image.dart';
import 'package:quick_pitch_app/features/task_detail/fixer/view/screen/fixer_side_detail_screen.dart';

class FixerExploreTaskCard extends StatelessWidget {
  const FixerExploreTaskCard({
    super.key,
    required this.context,
    required this.task,
    required this.res,
  });

  final BuildContext context;
  final dynamic task;
  final Responsive res;

  @override
  Widget build(BuildContext context) {
    final imageUrl = task.imagesUrl?.isNotEmpty == true ? task.imagesUrl!.first : null;

    return GestureDetector(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => FixerSideDetailScreen(task: task)),
      ),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        padding: EdgeInsets.all(res.wp(2.5)),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.93),
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.07),
              blurRadius: 8,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            FixerExploreScreenTaskImage(imageUrl: imageUrl, res: res),
            SizedBox(height: res.hp(1)),
            Text(
              task.title,
              style: TextStyle(fontSize: res.sp(13), fontWeight: FontWeight.w600),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            SizedBox(height: res.hp(0.5)),
            Text(
              task.description,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(fontSize: res.sp(11), color: Colors.grey[700]),
            ),
            const Spacer(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "₹${task.budget}",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: res.sp(12)),
                ),
                Text(
                  DateFormat.MMMd().format(task.deadline),
                  style: TextStyle(fontSize: res.sp(10), color: Colors.grey[600]),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
