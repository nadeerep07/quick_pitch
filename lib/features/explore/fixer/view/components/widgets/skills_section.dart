import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quick_pitch_app/core/config/app_colors.dart';
import 'package:quick_pitch_app/features/explore/fixer/viewmodel/cubit/fixer_explore_cubit.dart';

class SkillsSection extends StatelessWidget {
  const SkillsSection({super.key});

  @override
  Widget build(BuildContext context) {
    final state = context.watch<FixerExploreCubit>().state;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Skills/Specialties',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 10),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: state.tasks
              .expand((task) => task.skills)
              .toSet()
              .map(
                (skill) => FilterChip(
                  label: Text(skill),
                  selected: state.selectedSkills.contains(skill),
                  onSelected: (_) {
                    context.read<FixerExploreCubit>().toggleSkill(skill);
                  },
                  selectedColor: AppColors.primaryColor.withOpacity(0.2),
                  checkmarkColor: AppColors.primaryColor,
                ),
              )
              .toList(),
        ),
      ],
    );
  }
}
