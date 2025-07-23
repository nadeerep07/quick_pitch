import 'package:flutter/material.dart';
import 'package:quick_pitch_app/core/config/responsive.dart';
import 'package:quick_pitch_app/features/profile_completion/model/user_profile_model.dart';

class FixerDetailSkillSection extends StatelessWidget {
  const FixerDetailSkillSection({
    super.key,
    required this.fixerData,
    required this.res,
    required this.theme,
  });

  final UserProfileModel fixerData;
  final Responsive res;
  final ThemeData theme;

  @override
  Widget build(BuildContext context) {
    final skills = fixerData.fixerData?.skills ?? [];
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Skills & Expertise',
          style: theme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: res.hp(1)),
        Wrap(
          spacing: res.wp(2),
          runSpacing: res.hp(1),
          children: skills.map((skill) => Chip(
            label: Text(
              skill,
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.primary,
              ),
            ),
            backgroundColor: theme.colorScheme.primary.withValues(alpha: .1),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          )).toList(),
        ),
      ],
    );
  }
}
