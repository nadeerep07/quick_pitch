import 'package:flutter/material.dart';
import 'package:quick_pitch_app/core/config/responsive.dart';
import 'package:quick_pitch_app/features/pitch_detail/fixer/view/components/fixer_pitch_detail_item.dart';
import 'package:quick_pitch_app/features/poster_task/model/task_post_model.dart';

class FixerPitchDetailTaskCard extends StatelessWidget {
  const FixerPitchDetailTaskCard({
    super.key,
    required this.res,
    required this.task,
    required this.theme,
    required this.colorScheme,
  });

  final Responsive res;
  final TaskPostModel task;
  final ThemeData theme;
  final ColorScheme colorScheme;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(
          color: colorScheme.outline.withOpacity(0.2),
          width: 1,
        ),
      ),
      child: Padding(
        padding: EdgeInsets.all(res.wp(4)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'TASK DETAILS',
              style: theme.textTheme.labelSmall?.copyWith(
                color: colorScheme.onSurface.withOpacity(0.6),
                letterSpacing: 1,
              ),
            ),
            SizedBox(height: res.hp(2)),
            
            FixerPitchDetailItem(res: res, icon: Icons.work_outline, label: 'Title', value: task.title, theme: theme, colorScheme: colorScheme),
            SizedBox(height: res.hp(2)),
            
            FixerPitchDetailItem(res: res, icon: Icons.description, label: 'Description', value: task.description, theme: theme, colorScheme: colorScheme),
            
            ...[
            SizedBox(height: res.hp(2)),
            FixerPitchDetailItem(res: res, icon: Icons.attach_money, label: 'Budget', value: '\$${task.budget.toStringAsFixed(2)}', theme: theme, colorScheme: colorScheme),
          ],
          ],
        ),
      ),
    );
  }
}
