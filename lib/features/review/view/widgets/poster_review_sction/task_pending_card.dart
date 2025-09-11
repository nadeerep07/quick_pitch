import 'package:flutter/material.dart';
import 'package:quick_pitch_app/core/config/responsive.dart';

class TaskPendingCard extends StatelessWidget {
  final Responsive res;
  final ThemeData theme;

  const TaskPendingCard({required this.res, required this.theme});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(res.wp(3)),
      decoration: BoxDecoration(
        color: Colors.orange.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.orange.withOpacity(0.3)),
      ),
      child: Row(
        children: [
          Icon(Icons.pending, color: Colors.orange[600], size: res.wp(5)),
          SizedBox(width: res.wp(3)),
          Expanded(
            child: Text(
              'Reviews can be submitted after task completion',
              style: theme.textTheme.bodyMedium?.copyWith(color: Colors.orange[700]),
            ),
          ),
        ],
      ),
    );
  }
}