import 'package:flutter/material.dart';
import 'package:quick_pitch_app/core/config/responsive.dart';
import 'package:quick_pitch_app/features/task_pitching/model/pitch_model.dart';

class FixerPitchDetailRejectionCard extends StatelessWidget {
  const FixerPitchDetailRejectionCard({
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
    color: Colors.red[50],
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(16),
      side: BorderSide(color: Colors.red[100]!, width: 1),
    ),
    child: Padding(
      padding: EdgeInsets.all(res.wp(4)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.info_outline, color: Colors.red[400]),
              SizedBox(width: res.wp(3)),
              Text(
                'Pitch Rejected',
                style: theme.textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: Colors.red[600],
                ),
              ),
            ],
          ),
          SizedBox(height: res.hp(1.5)),
          if (currentPitch.rejectionMessage != null) ...[
            Text(
              'Feedback:',
              style: theme.textTheme.bodySmall?.copyWith(
                fontWeight: FontWeight.w600,
                color: Colors.red[600],
              ),
            ),
            SizedBox(height: res.hp(0.8)),
            Text(
              currentPitch.rejectionMessage!,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: Colors.red[800],
              ),
            ),
          ],
        ],
      ),
    ),
  );
}
}
