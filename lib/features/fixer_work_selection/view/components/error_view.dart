import 'package:flutter/material.dart';
import 'package:quick_pitch_app/core/config/responsive.dart';

class ErrorView extends StatelessWidget {
  final Responsive res;
  final ThemeData theme;

  const ErrorView({super.key, required this.res, required this.theme});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(res.wp(8)),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline, size: res.sp(64), color: theme.colorScheme.error),
            SizedBox(height: res.hp(2)),
            Text('Unable to load works',
                style: theme.textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold)),
            SizedBox(height: res.hp(1)),
            Text(
              'Please try again later',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurface.withValues(alpha:0.7),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
