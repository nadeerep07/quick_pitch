import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:quick_pitch_app/core/config/responsive.dart';

/// --------------------------
/// Poster info (name + date)
/// --------------------------
class PosterInfo extends StatelessWidget {
  final String? posterName;
  final DateTime createdAt;
  final ThemeData theme;
  final ColorScheme colorScheme;
  final Responsive res;

  const PosterInfo({
    required this.posterName,
    required this.createdAt,
    required this.theme,
    required this.colorScheme,
    required this.res,
  });

  String _formatDate(DateTime date) {
    final formatter = DateFormat('MMM dd, yyyy');
    return formatter.format(date);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          posterName ?? 'Unknown Poster',
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(height: res.hp(0.5)),
        Text(
          'Submitted ${_formatDate(createdAt)}',
          style: theme.textTheme.bodySmall?.copyWith(
            color: colorScheme.onSurface.withValues(alpha: 0.6),
          ),
        ),
      ],
    );
  }
}

