import 'package:flutter/material.dart';
import 'package:quick_pitch_app/core/config/app_colors.dart';
import 'package:quick_pitch_app/core/config/responsive.dart';
import 'package:quick_pitch_app/features/profile_completion/model/user_profile_model.dart';

class SkillsSection extends StatelessWidget {
  final UserProfileModel fixer;
  final Responsive res;

  const SkillsSection({super.key, required this.fixer, required this.res});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Skills', style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
        SizedBox(height: res.hp(1)),
        Wrap(
          spacing: res.wp(2),
          runSpacing: res.hp(1),
          children: fixer.fixerData!.skills!.take(5).map((skill) {
            return Container(
              padding: EdgeInsets.symmetric(horizontal: res.wp(3), vertical: res.hp(0.5)),
              decoration: BoxDecoration(
                color: AppColors.primary.withOpacity(0.1),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(skill, style: TextStyle(color: AppColors.primary, fontSize: res.sp(12))),
            );
          }).toList(),
        ),
        SizedBox(height: res.hp(2)),
      ],
    );
  }
}
