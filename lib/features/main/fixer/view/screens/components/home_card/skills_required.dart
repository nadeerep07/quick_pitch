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
    return Wrap(
      spacing: 6,
      runSpacing: 1,
      children: skills.map((skill) {
        return Chip(
          label: Text(
            maxLines: 1,
            skill,
            style: TextStyle(
              fontSize: res.sp(11),
              color: Colors.black,
            ),
          ),
          backgroundColor: Colors.grey[200],
          shape: const StadiumBorder(),
          materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
        );
      }).toList(),
    );
  }
}
