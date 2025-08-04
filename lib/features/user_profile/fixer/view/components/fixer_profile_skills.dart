import 'package:flutter/material.dart';
import 'package:quick_pitch_app/core/config/app_colors.dart';
import 'package:quick_pitch_app/features/user_profile/fixer/view/components/fixer_prodile_modern.dart';

class SkillsSection extends StatelessWidget {
  final List<dynamic> skills;
  final ThemeData theme;

  const SkillsSection({
    super.key,
    required this.skills,
    required this.theme,
  });

  @override
  Widget build(BuildContext context) {
    return ModernProfileSection(
      title: 'Skills & Expertise',
      child: Wrap(
        spacing: 8,
        runSpacing: 8,
        children: skills
            .map<Widget>((skill) => Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    skill.toString(),
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: AppColors.primary,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ))
            .toList(),
      ),
    );
  }
}