import 'package:flutter/material.dart';
import 'package:quick_pitch_app/core/config/responsive.dart';
import 'package:quick_pitch_app/features/profile_completion/model/user_profile_model.dart';

class FixerSkills extends StatelessWidget {
  final UserProfileModel fixer;
  final Responsive res;
  final ThemeData theme;

  const FixerSkills({
    super.key,
    required this.fixer,
    required this.res,
    required this.theme,
  });

  @override
  Widget build(BuildContext context) {
    if (fixer.fixerData?.skills?.isEmpty ?? true) return const SizedBox();
    return Wrap(
      spacing: res.wp(1),
      runSpacing: res.hp(0.5),
      children: fixer.fixerData!.skills!.take(3).map((skill) {
        return Container(
          padding: EdgeInsets.symmetric(
            horizontal: res.wp(2),
            vertical: res.hp(0.3),
          ),
          decoration: BoxDecoration(
            color: theme.primaryColor.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(6),
          ),
          child: Text(
            skill,
            style: TextStyle(
              fontSize: res.sp(10),
              color: theme.primaryColor,
              fontWeight: FontWeight.w500,
            ),
          ),
        );
      }).toList(),
    );
  }
}
