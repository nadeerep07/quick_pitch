
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:quick_pitch_app/core/config/responsive.dart';
import 'package:quick_pitch_app/features/task_pitching/model/pitch_model.dart';

class FixerPitchHeaderCard extends StatelessWidget {
  final PitchModel currentPitch;
  final Responsive res;
  final ThemeData theme;
  final ColorScheme colorScheme;

  const FixerPitchHeaderCard({super.key, 
    required this.currentPitch,
    required this.res,
    required this.theme,
    required this.colorScheme,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(
          color: colorScheme.outline.withValues(alpha: 0.2),
          width: 1,
        ),
      ),
      child: Padding(
        padding: EdgeInsets.all(res.wp(4)),
        child: Row(
          children: [
            Container(
              width: res.sp(50),
              height: res.sp(50),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: colorScheme.primary.withValues(alpha: 0.2),
                  width: 2,
                ),
              ),
              child: ClipOval(
                child:
                    currentPitch.posterImage != null
                        ? Image.network(
                          currentPitch.posterImage!,
                          fit: BoxFit.cover,
                          errorBuilder:
                              (_, __, ___) => Icon(
                                Icons.person,
                                size: res.sp(24),
                                color: colorScheme.primary,
                              ),
                        )
                        : Icon(
                          Icons.person,
                          size: res.sp(24),
                          color: colorScheme.primary,
                        ),
              ),
            ),
            SizedBox(width: res.wp(4)),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    currentPitch.posterName ?? 'Unknown Poster',
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(height: res.hp(0.5)),
                  Text(
                    'Submitted ${_formatDate(currentPitch.createdAt)}',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: colorScheme.onSurface.withValues(alpha: 0.6),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              padding: EdgeInsets.symmetric(
                horizontal: res.wp(3),
                vertical: res.hp(0.8),
              ),
              decoration: BoxDecoration(
                color: _getStatusColor(
                  currentPitch.status,
                ).withValues(alpha: .1),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: _getStatusColor(currentPitch.status),
                  width: 1,
                ),
              ),
              child: Text(
                currentPitch.status.toUpperCase(),
                style: theme.textTheme.labelSmall?.copyWith(
                  color: _getStatusColor(currentPitch.status),
                  fontWeight: FontWeight.w600,
                  letterSpacing: 0.5,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
  String _formatDate(DateTime date) {
    final formatter = DateFormat('MMM dd, yyyy');
    return formatter.format(date);
  }

_getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'pending':
        return Colors.orange;
      case 'accepted':
        return Colors.green;
      case 'rejected':
        return Colors.red;
      case 'completed':
        return Colors.blue;
      default:
        return Colors.grey;
    }
  }
}
