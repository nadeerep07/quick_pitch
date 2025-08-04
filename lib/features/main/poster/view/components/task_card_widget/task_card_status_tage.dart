import 'package:flutter/material.dart';
import 'package:quick_pitch_app/core/config/responsive.dart';

class TaskCardStatusTage extends StatelessWidget {
  const TaskCardStatusTage({
    super.key,
    required Color statusColor,
    required IconData statusIcon,
    required this.status,
    required this.res,
    required this.context,
  }) : _statusColor = statusColor, _statusIcon = statusIcon;

  final Color _statusColor;
  final IconData _statusIcon;
  final String status;
  final Responsive res;
  final BuildContext context;

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 12,
      right: 12,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        decoration: BoxDecoration(
          color: _statusColor.withValues(alpha: 0.9),
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.1),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(_statusIcon, color: Colors.white, size: 14),
            const SizedBox(width: 6),
            Text(
              status.toUpperCase(),
              style: TextStyle(
                color: Colors.white,
                fontSize: res.sp(10),
                fontWeight: FontWeight.w600,
                letterSpacing: 0.5,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
