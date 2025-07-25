import 'package:flutter/material.dart';
import 'package:quick_pitch_app/core/config/responsive.dart';
import 'package:quick_pitch_app/features/main/poster/view/components/task_card_widget/poster_home_task_card_widget.dart';
import 'package:quick_pitch_app/features/main/poster/view/components/task_card_widget/task_card_image_overlay.dart';
import 'package:quick_pitch_app/features/main/poster/view/components/task_card_widget/task_card_status_tage.dart';

class TaskCardImageStatus extends StatelessWidget {
  const TaskCardImageStatus({
    super.key,
    required this.res,
    required this.imageUrl,
    required Color statusColor,
    required IconData statusIcon,
    required this.status,
    required this.context,
  }) : _statusColor = statusColor, _statusIcon = statusIcon;

  final Responsive res;
  final String imageUrl;
  final Color _statusColor;
  final IconData _statusIcon;
  final String status;
  final BuildContext context;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        PosterHomeTaskCardWidget(res: res, imageUrl: imageUrl),
        TaskCardImageOverlay(),
        TaskCardStatusTage(statusColor: _statusColor, statusIcon: _statusIcon, status: status, res: res, context: context),
      ],
    );
  }
}
