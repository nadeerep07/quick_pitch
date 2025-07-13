import 'package:flutter/material.dart';
import 'package:quick_pitch_app/features/task_post/poster_task/viewmodel/cubit/task_post_cubit.dart';

class TaskSkillSelector extends StatelessWidget {
  final TaskPostCubit cubit;
  const TaskSkillSelector({super.key, required this.cubit});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _label("Required Skills"),
        TextField(
          controller: cubit.searchController,
          onChanged: cubit.updateSkillSuggestions,
          decoration: InputDecoration(
            hintText: "Search or add skill",
            prefixIcon: Icon(Icons.search),
          ),
        ),

        Wrap(
          spacing: 8,
          children:
              cubit.suggestedSkills.map((skill) {
                return FilterChip(
                  label: Text(skill),
                  selected: cubit.selectedSkills.contains(skill),
                  onSelected: (_) => cubit.toggleSkill(skill),
                );
              }).toList(),
        ),
        SizedBox(height: 12),
        _label("Selected Skills"),
        Wrap(
          spacing: 8,
          children:
              cubit.selectedSkills.map((skill) {
                return InputChip(
                  label: Text(skill),
                  onDeleted: () => cubit.toggleSkill(skill),
                );
              }).toList(),
        ),
      ],
    );
  }

  Widget _label(String text) => Padding(
    padding: const EdgeInsets.only(top: 12, bottom: 6),
    child: Text(
      text,
      style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
    ),
  );
}
