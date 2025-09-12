import 'package:flutter/material.dart';
import 'package:quick_pitch_app/core/config/responsive.dart';
import 'package:quick_pitch_app/core/utils/status_color_util.dart';
import 'package:quick_pitch_app/features/fixer_work_selection/model/work_request_model.dart';

class StatusCard extends StatelessWidget {
  final HireRequest request;

  const StatusCard({super.key, required this.request});

  @override
  Widget build(BuildContext context) {
    final res = Responsive(context);
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final statusColor =
        StatusColorUtil.getStatusColor(request.status.displayName, theme);

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(res.wp(4)),
      decoration: BoxDecoration(
        color: statusColor.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: statusColor.withValues(alpha: 0.3)),
      ),
      child: Row(
        children: [
          Icon(
            _getStatusIcon(request.status),
            color: statusColor,
            size: res.wp(6),
          ),
          SizedBox(width: res.wp(3)),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Status',
                style: TextStyle(
                  fontSize: res.sp(12),
                  color: colorScheme.onSurface.withValues(alpha: 0.7),
                ),
              ),
              Text(
                request.status.displayName,
                style: TextStyle(
                  fontSize: res.sp(18),
                  fontWeight: FontWeight.bold,
                  color: statusColor,
                ),
              ),
            ],
          ),
          const Spacer(),
          if (request.respondedAt != null)
            Text(
              _formatDate(request.respondedAt!),
              style: TextStyle(
                fontSize: res.sp(12),
                color: colorScheme.onSurface.withValues(alpha: 0.7),
              ),
            ),
        ],
      ),
    );
  }

  IconData _getStatusIcon(HireRequestStatus status) {
    switch (status) {
      case HireRequestStatus.pending:
        return Icons.hourglass_empty;
      case HireRequestStatus.accepted:
        return Icons.check_circle;
      case HireRequestStatus.declined:
        return Icons.cancel;
      case HireRequestStatus.completed:
        return Icons.task_alt;
      case HireRequestStatus.cancelled:
        return Icons.block;
    }
  }
}
String _formatDate(DateTime date) {
  return '${date.day}/${date.month}/${date.year}';
}