import 'package:flutter/material.dart';
import 'package:quick_pitch_app/core/config/responsive.dart';

/// ---------------------------
/// 🔹 EMPTY STATE
/// ---------------------------
class PortfolioEmptyView extends StatelessWidget {
  final Responsive res;
  final ThemeData theme;

  const PortfolioEmptyView({
    super.key,
    required this.res,
    required this.theme,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(res.wp(6)),
      margin: EdgeInsets.only(bottom: res.hp(2)),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHighest.withOpacity(0.5),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: theme.colorScheme.outline.withOpacity(0.1),
        ),
      ),
      child: Column(
        children: [
          Icon(
            Icons.work_outline_rounded,
            size: res.hp(8),
            color: theme.colorScheme.outline.withOpacity(0.5),
          ),
          SizedBox(height: res.hp(2)),
          Text(
            'No portfolio items yet',
            style: theme.textTheme.titleMedium?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: res.hp(1)),
          Text(
            'This fixer hasn\'t uploaded any work samples yet.\nCheck back later to see their portfolio.',
            textAlign: TextAlign.center,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.outline,
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }
}

