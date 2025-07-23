// Section-wise refactored FixerProfileScreen

import 'package:flutter/material.dart';
import 'package:quick_pitch_app/core/config/responsive.dart';

class FixerProfileBasicInfo extends StatelessWidget {
  const FixerProfileBasicInfo({
    super.key,
    required this.profile,
    required this.theme,
    required this.res,
  });

  final dynamic profile;
  final ThemeData theme;
  final Responsive res;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          profile.name,
          style: theme.textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
        ),
        SizedBox(height: res.hp(0.5)),
        Row(
          children: [
            Icon(Icons.location_on, size: res.wp(4), color: Colors.grey.shade600),
            SizedBox(width: res.wp(1)),
            Text(
              profile.location,
              style: theme.textTheme.bodyMedium?.copyWith(color: Colors.grey.shade600),
            ),
          ],
        ),
      ],
    );
  }
}
