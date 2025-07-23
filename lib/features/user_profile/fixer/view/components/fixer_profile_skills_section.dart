// Section-wise refactored FixerProfileScreen

import 'package:flutter/material.dart';
import 'package:quick_pitch_app/core/config/responsive.dart';

class FixerProfileSkillsSection extends StatelessWidget {
  const FixerProfileSkillsSection({
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
        SizedBox(height: res.hp(2)),
        Text('Skills & Expertise', style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
        SizedBox(height: res.hp(1)),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: profile.fixerData!.skills!
              .map<Widget>((skill) => Chip(
                    label: Text(skill),
                    backgroundColor: Colors.blue.shade50,
                    labelStyle: TextStyle(color: Colors.blue.shade800, fontWeight: FontWeight.w500),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  ))
              .toList(),
        ),
      ],
    );
  }
}
