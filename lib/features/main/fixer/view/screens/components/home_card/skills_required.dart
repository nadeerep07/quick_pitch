import 'package:flutter/material.dart';
import 'package:quick_pitch_app/core/config/responsive.dart';

class SkillsRequired extends StatelessWidget {
  const SkillsRequired({
    super.key,
    required this.skills,
    required this.res,
  });

  final List skills;
  final Responsive res;

  @override
  Widget build(BuildContext context) {
    final visibleSkills = skills.length > 2 ? skills.sublist(0, 2) : skills;
    final remainingCount = skills.length - visibleSkills.length;

    return SingleChildScrollView(
  scrollDirection: Axis.horizontal,
  child: Row(
    children: [
      ...visibleSkills.map(
        (skill) => Padding(
          padding: const EdgeInsets.only(right: 6.0),
          child: Chip(
            label: Text(
              skill,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: res.sp(11),
                color: Colors.black,
              ),
            ),
            backgroundColor: Colors.grey[200],
            shape: const StadiumBorder(),
            materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
          ),
        ),
      ),
      if (remainingCount > 0)
        Chip(
          label: Text(
            '+$remainingCount more',
            style: TextStyle(
              fontSize: res.sp(11),
              color: Colors.black54,
            ),
          ),
          backgroundColor: Colors.grey[300],
          shape: const StadiumBorder(),
          materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
        ),
    ],
  ),
);

  }
}
