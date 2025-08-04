import 'package:flutter/material.dart';
import 'package:quick_pitch_app/core/config/responsive.dart';
import 'package:quick_pitch_app/features/task_pitching/view/components/pitch_detail_chip.dart';
import 'package:quick_pitch_app/features/task_pitching/view/screen/task_pitching_screen.dart';

class PitchTaskDetails extends StatelessWidget {
  const PitchTaskDetails({
    super.key,
    required this.context,
    required this.widget,
    required this.res,
    required this.colorScheme,
  });

  final BuildContext context;
  final TaskPitchingScreen widget;
  final Responsive res;
  final ColorScheme colorScheme;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(res.wp(3.5)),
        gradient: LinearGradient(
          colors: [colorScheme.primaryContainer, colorScheme.secondaryContainer],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: res.wp(2.5),
            offset: Offset(0, res.hp(0.5)),
          ),
        ],
      ),
      child: Padding(
        padding: EdgeInsets.all(res.wp(4)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.assignment, color: colorScheme.onPrimaryContainer, size: res.wp(5)),
                SizedBox(width: res.wp(2)),
                Text(
                  'TASK DETAILS',
                  style: Theme.of(context).textTheme.labelLarge?.copyWith(
                    fontSize: res.sp(12),
                    fontWeight: FontWeight.bold,
                    color: colorScheme.onPrimaryContainer.withValues(alpha: 0.8),
                    letterSpacing: 1.2,
                  ),
                ),
              ],
            ),
            SizedBox(height: res.hp(1.5)),
            Text(
              widget.taskData.title,
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontSize: res.sp(18),
                fontWeight: FontWeight.bold,
                color: colorScheme.onPrimaryContainer,
              ),
            ),
            SizedBox(height: res.hp(1)),
            Text(
              widget.taskData.description,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                fontSize: res.sp(14),
                color: colorScheme.onPrimaryContainer.withValues(alpha: 0.9),
              ),
            ),
            SizedBox(height: res.hp(2)),
            Row(
              children: [
                DetailChip(
                  icon: Icons.attach_money,
                  text: '\$${widget.taskData.budget}',
                  color: colorScheme.onPrimaryContainer,
                  res: res,
                ),
                SizedBox(width: res.wp(2)),
                DetailChip(
                  icon: Icons.calendar_today,
                  text: widget.taskData.deadline.toLocal().toString().split(' ')[0],
                  color: colorScheme.onPrimaryContainer,
                  res: res,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
