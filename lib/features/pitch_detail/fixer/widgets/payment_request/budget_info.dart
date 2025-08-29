import 'package:flutter/material.dart';
import 'package:quick_pitch_app/core/config/responsive.dart';
import 'package:quick_pitch_app/features/task_pitching/model/pitch_model.dart';

class BudgetInfo extends StatelessWidget {
  final Responsive res;
  final PitchModel pitch;
  final ThemeData theme;
  const BudgetInfo({required this.res, required this.pitch, required this.theme});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(res.wp(3)),
      decoration: BoxDecoration(
        color: Colors.blue[50],
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.blue[200]!),
      ),
      child: Row(
        children: [
          Icon(Icons.info_outline, color: Colors.blue[600], size: res.wp(4)),
          SizedBox(width: res.wp(2)),
          Text(
            'Original Budget: \$${pitch.budget.toStringAsFixed(2)}',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: Colors.blue[700],
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
