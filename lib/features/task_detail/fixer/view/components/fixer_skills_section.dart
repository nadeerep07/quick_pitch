import 'package:flutter/material.dart';
import 'package:quick_pitch_app/core/config/responsive.dart';
import 'package:quick_pitch_app/features/task_detail/fixer/view/components/fixer_detail_info_card.dart';

class FixerSkillsSection extends StatelessWidget {
  final List<String> skills;
  final Responsive res;

  const FixerSkillsSection({
    super.key,
    required this.skills,
    required this.res,
  });

  @override
  Widget build(BuildContext context) {
    if (skills.isEmpty) return const SizedBox.shrink();

    return FixerDetailInfoCard(
      res: res,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Skills Required:',
            style: TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: res.sp(13),
            ),
          ),
          SizedBox(height: res.hp(1)),
          Wrap(
            spacing: 8,
            runSpacing: 6,
            children: skills
                .map((skill) => Chip(
                      label: Text(
                        skill,
                        style: TextStyle(fontSize: res.sp(11)),
                      ),
                      backgroundColor: Colors.grey.shade200,
                    ))
                .toList(),
          ),
        ],
      ),
    );
  }
}
