import 'package:flutter/material.dart';
import 'package:quick_pitch_app/features/explore/poster/viewmodel/cubit/poster_explore_state.dart';

class ExploreSkillsFilter extends StatelessWidget {
  final PosterExploreLoaded state;
  final Function(String) onSkillToggle;

  const ExploreSkillsFilter({
    super.key,
    required this.state,
    required this.onSkillToggle,
  });

  @override
  Widget build(BuildContext context) {
    if (state.skills.isEmpty) return const SizedBox.shrink();

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      height: 35,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: state.skills.length,
        itemBuilder: (context, index) {
          final skill = state.skills[index];
          final isSelected = state.selectedSkills.contains(skill);

          return GestureDetector(
            onTap: () => onSkillToggle(skill),
            child: Container(
              margin: const EdgeInsets.only(right: 8),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: isSelected ? Colors.blue.withOpacity(0.1) : Colors.grey[100],
                borderRadius: BorderRadius.circular(18),
                border: Border.all(
                  color: isSelected ? Colors.blue : Colors.transparent,
                  width: 1,
                ),
              ),
              child: Text(
                skill,
                style: TextStyle(
                  color: isSelected ? Colors.blue : Colors.grey[700],
                  fontSize: 14,
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
