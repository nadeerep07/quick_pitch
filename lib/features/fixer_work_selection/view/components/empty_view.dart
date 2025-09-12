import 'package:flutter/material.dart';
import 'package:quick_pitch_app/core/config/responsive.dart';

class EmptyView extends StatelessWidget {
  final Responsive res;
  final ThemeData theme;
  final String fixerName;

  const EmptyView({super.key, 
    required this.res,
    required this.theme,
    required this.fixerName,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(res.wp(8)),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.work_off_outlined, size: res.sp(64), color: theme.colorScheme.outline),
            SizedBox(height: res.hp(2)),
            Text(
              'No Works Available',
              style: theme.textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
            ),
            SizedBox(height: res.hp(1)),
            Text(
              '${fixerName.split(" ").first} hasn\'t uploaded any works yet.',
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
