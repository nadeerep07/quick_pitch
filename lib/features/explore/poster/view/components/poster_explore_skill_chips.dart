import 'package:flutter/material.dart';
import 'package:quick_pitch_app/core/config/app_colors.dart';
import 'package:quick_pitch_app/core/config/responsive.dart';
import 'package:quick_pitch_app/core/config/string_extension.dart';

class PosterExploreSkillChips extends StatelessWidget {
  final List<String> skills;
  final List<String> selectedSkills;
  final Function(String) onTap;
  final VoidCallback? onMoreTap; // optional callback for "More"

  const PosterExploreSkillChips({
    super.key,
    required this.skills,
    required this.selectedSkills,
    required this.onTap,
    this.onMoreTap,
  });

  @override
  Widget build(BuildContext context) {
    final res = Responsive(context);
    final theme = Theme.of(context);

    if (skills.isEmpty) return const SizedBox.shrink();

    // limit to 4 skills
    final displayCount = skills.length > 4 ? 4 : skills.length;
    final showMore = skills.length > 4;

    return SizedBox(
      height: res.hp(5),
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: displayCount + (showMore ? 1 : 0), // add 1 for "More"
        separatorBuilder: (context, index) => SizedBox(width: res.wp(2)),
        itemBuilder: (context, index) {
          // If this is the "More" button
          if (showMore && index == displayCount) {
            return GestureDetector(
              onTap: onMoreTap ??
                  () {
                    // default behavior if no callback
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("Show more skills...")),
                    );
                  },
              child: Container(
                padding: EdgeInsets.symmetric(
                  horizontal: res.wp(4),
                  vertical: res.hp(1),
                ),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha:0.2),
                  borderRadius: BorderRadius.circular(25),
                  border: Border.all(
                    color: Colors.white.withValues(alpha:0.5),
                  ),
                ),
                child: Text(
                  "More",
                  style: TextStyle(
                    color: AppColors.primaryText,
                    fontSize: res.sp(14),
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            );
          }

          // Otherwise, show skill chip
          final skill = skills[index];
          final isSelected = selectedSkills.contains(skill);

          return GestureDetector(
            onTap: () => onTap(skill),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              padding: EdgeInsets.symmetric(
                horizontal: res.wp(4),
                vertical: res.hp(1),
              ),
              decoration: BoxDecoration(
                color: isSelected ? Colors.white : Colors.white.withValues(alpha:0.2),
                borderRadius: BorderRadius.circular(25),
                border: Border.all(
                  color: isSelected
                      ? theme.primaryColor
                      : Colors.white.withValues(alpha:0.5),
                  width: isSelected ? 2 : 1,
                ),
                boxShadow: isSelected
                    ? [
                        BoxShadow(
                          color: Colors.black.withValues(alpha:0.1),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ]
                    : null,
              ),
              child: Text(
                skill.capitalize(),
                style: TextStyle(
                  color: isSelected ? theme.primaryColor : AppColors.primaryText,
                  fontSize: res.sp(14),
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
