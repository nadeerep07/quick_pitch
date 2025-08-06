import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:quick_pitch_app/core/config/responsive.dart';
import 'package:quick_pitch_app/features/pitch_detail/fixer/view/components/fixer_pitch_detail_item.dart';
import 'package:quick_pitch_app/features/task_pitching/model/pitch_model.dart';

class FixerPitchDetailCompletionSection extends StatelessWidget {
  const FixerPitchDetailCompletionSection({
    super.key,
    required this.res,
    required this.theme,
    required this.colorScheme,
    required this.currentPitch,
  });

  final Responsive res;
  final ThemeData theme;
  final ColorScheme colorScheme;
  final PitchModel currentPitch;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      color: Colors.green[50],
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(
          color: Colors.green[100]!,
          width: 1,
        ),
      ),
      child: Padding(
        padding: EdgeInsets.all(res.wp(4)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.check_circle, color: Colors.green[400]),
                SizedBox(width: res.wp(3)),
                Text(
                  'Task Completed',
                  style: theme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: Colors.green[600],
                  ),
                ),
              ],
            ),
            SizedBox(height: res.hp(1.5)),
            
            if (currentPitch.completionDate != null) ...[
              FixerPitchDetailItem(res: res, icon: Icons.calendar_today, label: 'Completed On', value: DateFormat('MMM dd, yyyy').format(currentPitch.completionDate!), theme: theme, colorScheme: colorScheme),
              SizedBox(height: res.hp(1)),
            ],
            
            if (currentPitch.completionNotes != null)
              FixerPitchDetailItem(res: res, icon: Icons.note, label: 'Completion Notes', value: currentPitch.completionNotes!, theme: theme, colorScheme: colorScheme),
          ],
        ),
      ),
    );
  }
}
