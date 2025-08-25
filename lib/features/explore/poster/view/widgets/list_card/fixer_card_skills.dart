import 'package:flutter/material.dart';
import 'package:quick_pitch_app/core/config/responsive.dart';
import 'package:quick_pitch_app/features/profile_completion/model/user_profile_model.dart';

class FixerCardSkills extends StatelessWidget {
  final UserProfileModel fixer;

  const FixerCardSkills({super.key, required this.fixer});

  @override
  Widget build(BuildContext context) {
    final res = Responsive(context);

    if (fixer.fixerData?.skills == null || fixer.fixerData!.skills!.isEmpty) {
      return const SizedBox.shrink();
    }

    return Wrap(
      spacing: res.wp(2),
      runSpacing: res.hp(1),
      children: fixer.fixerData!.skills!.take(4).map((skill) {
        return Container(
          padding: EdgeInsets.symmetric(
            horizontal: res.wp(3.5),
            vertical: res.hp(0.8),
          ),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Colors.blue.withOpacity(0.1),
                Colors.blue.withOpacity(0.05),
              ],
            ),
            borderRadius: BorderRadius.circular(res.wp(6)),
            border: Border.all(
              color: Colors.blue.withOpacity(0.2),
              width: 1,
            ),
          ),
          child: Text(
            skill,
            style: TextStyle(
              color: Colors.blue[700],
              fontSize: res.sp(13),
              fontWeight: FontWeight.w600,
              letterSpacing: 0.2,
            ),
          ),
        );
      }).toList(),
    );
  }
}
