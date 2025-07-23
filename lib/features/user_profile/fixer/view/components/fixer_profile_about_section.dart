// Section-wise refactored FixerProfileScreen

import 'package:flutter/material.dart';
import 'package:quick_pitch_app/core/config/responsive.dart';

class FixerProfileAboutSection extends StatelessWidget {
  const FixerProfileAboutSection({
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
        Text('About', style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
        SizedBox(height: res.hp(1)),
        Container(
          width: double.infinity,
          padding: EdgeInsets.all(res.wp(4)),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 8, offset: const Offset(0, 4))],
          ),
          child: Text(profile.fixerData!.bio, style: theme.textTheme.bodyMedium),
        ),
      ],
    );
  }
}
