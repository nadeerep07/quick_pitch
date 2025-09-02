import 'package:flutter/material.dart';
import 'package:quick_pitch_app/core/config/responsive.dart';

/// ---------------------------
/// 🔹 ERROR STATE
/// ---------------------------
class PortfolioErrorView extends StatelessWidget {
  final Responsive res;
  final ThemeData theme;
  final String error;

  const PortfolioErrorView({
    super.key,
    required this.res,
    required this.theme,
    required this.error,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(res.wp(4)),
      margin: EdgeInsets.only(bottom: res.hp(2)),
      decoration: BoxDecoration(
        color: theme.colorScheme.errorContainer,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Icon(Icons.error, color: theme.colorScheme.error),
          SizedBox(width: res.wp(2)),
          Expanded(
            child: Text(
              'Error loading portfolio: $error',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onErrorContainer,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

