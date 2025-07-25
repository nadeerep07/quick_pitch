import 'package:flutter/material.dart';
import 'package:quick_pitch_app/core/config/responsive.dart';
import 'package:quick_pitch_app/features/main/poster/view/components/task_card_widget/task_card_details.dart';
import 'package:quick_pitch_app/features/main/poster/view/components/task_card_widget/task_card_image_status.dart';

class PosterHomeTaskCard extends StatelessWidget {
  final Responsive res;
  final String title;
  final String status;
  final String imageUrl;
  final String fixerName;

  const PosterHomeTaskCard({
    super.key,
    required this.res,
    required this.title,
    required this.status,
    required this.imageUrl,
    required this.fixerName,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: res.wp(60),
      margin: EdgeInsets.only(right: res.wp(4)),
      decoration: _buildCardDecoration(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TaskCardImageStatus(res: res, imageUrl: imageUrl, statusColor: _statusColor, statusIcon: _statusIcon, status: status, context: context),
          TaskCardDetails(res: res, title: title, fixerName: fixerName, context: context),
        ],
      ),
    );
  }

  BoxDecoration _buildCardDecoration() {
    return BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(16),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.08),
          blurRadius: 16,
          spreadRadius: 1,
          offset: const Offset(0, 4),
        ),
      ],
      border: Border.all(
        color: Colors.grey.withOpacity(0.1),
        width: 1,
      ),
    );
  }

  // Status properties
  Color get _statusColor {
    switch (status.toLowerCase()) {
      case 'completed':
        return const Color(0xFF4CAF50); // Material Green 500
      case 'in progress':
        return const Color(0xFFFF9800); // Material Orange 500
      case 'pending':
      default:
        return const Color(0xFFF44336); // Material Red 500
    }
  }

  IconData get _statusIcon {
    switch (status.toLowerCase()) {
      case 'completed':
        return Icons.check_circle_rounded;
      case 'in progress':
        return Icons.autorenew_rounded;
      case 'pending':
      default:
        return Icons.pending_actions_rounded;
    }
  }
}
