import 'package:flutter/material.dart';
import 'package:quick_pitch_app/core/config/responsive.dart';
import 'package:quick_pitch_app/core/utils/status_color_util.dart';

/// --------------------------
/// Status badge
/// --------------------------
class StatusBadge extends StatelessWidget {
  final String status;
  final ThemeData theme;
  final Responsive res;

  const StatusBadge({
    required this.status,
    required this.theme,
    required this.res,
  });

  @override
  Widget build(BuildContext context) {
    final statusColor = StatusColorUtil.getStatusColor(status, theme);

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: res.wp(3),
        vertical: res.hp(0.8),
      ),
      decoration: BoxDecoration(
        color: statusColor.withValues(alpha: .1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: statusColor, width: 1),
      ),
      child: Text(
        status.toUpperCase(),
        style: theme.textTheme.labelSmall?.copyWith(
          color: statusColor,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.5,
        ),
      ),
    );
  }
}

