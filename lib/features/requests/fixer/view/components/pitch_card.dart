import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:quick_pitch_app/core/config/app_colors.dart';
import 'package:quick_pitch_app/core/config/responsive.dart';
import 'package:quick_pitch_app/features/task_pitching/model/pitch_model.dart';

class PitchCard extends StatelessWidget {
  final PitchModel pitch;
  final Responsive res;
  final ThemeData theme;

  const PitchCard({
    super.key,
    required this.pitch,
    required this.res,
    required this.theme,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: theme.dividerColor.withValues(alpha: 0.1),
          width: 1,
        ),
      ),
      padding: EdgeInsets.all(res.wp(4)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              if (pitch.posterImage != null)
                CircleAvatar(
                  radius: res.wp(6),
                  backgroundImage: NetworkImage(pitch.posterImage!),
                ),
              SizedBox(width: res.wp(3)),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    pitch.posterName ?? "Unknown Poster",
                    style: TextStyle(
                      fontSize: res.sp(14),
                      fontWeight: FontWeight.w600,
                      color: AppColors.primaryText,
                    ),
                  ),
                  Text(
                    'Submitted ${_formatDate(pitch.createdAt.toIso8601String())}',
                    style: TextStyle(
                      fontSize: res.sp(12),
                      color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                    ),
                  ),
                ],
              ),
              const Spacer(),
              Container(
                padding: EdgeInsets.symmetric(
                  horizontal: res.wp(3),
                  vertical: res.wp(1),
                ),
                decoration: BoxDecoration(
                  color: _getStatusColor(pitch.status).withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  pitch.status.toUpperCase(),
                  style: TextStyle(
                    fontSize: res.sp(10),
                    fontWeight: FontWeight.w600,
                    color: _getStatusColor(pitch.status),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: res.wp(3)),
          Text(
            pitch.pitchText,
            style: TextStyle(
              fontSize: res.sp(16),
              fontWeight: FontWeight.w600,
              color: AppColors.primaryText,
            ),
          ),
          SizedBox(height: res.wp(2)),
          Row(
            children: [
              Text(
                "Budget: \$${pitch.budget}",
                style: TextStyle(
                  fontSize: res.sp(14),
                  fontWeight: FontWeight.bold,
                  color: theme.primaryColor,
                ),
              ),
              const Spacer(),
              Text(
                "Timeline: ${pitch.timeline}",
                style: TextStyle(
                  fontSize: res.sp(12),
                  color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'accepted':
        return Colors.green;
      case 'declined':
        return Colors.red;
      case 'pending':
        return Colors.orange;
      default:
        return Colors.grey;
    }
  }

  String _formatDate(String date) {
    try {
      final parsedDate = DateTime.parse(date);
      return DateFormat('MMM d, y').format(parsedDate);
    } catch (e) {
      return date;
    }
  }
}
