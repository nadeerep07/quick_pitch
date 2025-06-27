import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quick_pitch_app/features/profile_completion/viewmodel/cubit/complete_profile_cubit.dart';

class MultiSelectSkillChips extends StatelessWidget {
  const MultiSelectSkillChips({super.key});

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<CompleteProfileCubit>();

    return BlocBuilder<CompleteProfileCubit, CompleteProfileState>(
      buildWhen: (previous, current) =>
          current is SkillSelectionUpdated || current is SkillSearchUpdated,
      builder: (context, state) {
        final isSearching = cubit.searchQuery.isNotEmpty;
        final List<String> skillsToDisplay = isSearching
            ? cubit.filteredSkills
            : cubit.allSkills.take(3).toList();
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              onChanged: cubit.updateSearchQuery,
              decoration: InputDecoration(
                labelText: 'Search Skills',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              children: skillsToDisplay.map((skill) {
                final isSelected = cubit.selectedSkills.contains(skill);
                return FilterChip(
                  label: Text(skill),
                  selected: isSelected,
                  onSelected: (_) => cubit.toggleSkillSelection(skill),
                  selectedColor: Colors.blueAccent,
                  labelStyle: TextStyle(
                    color: isSelected ? Colors.white : Colors.black,
                  ),
                );
              }).toList(),
            ),
            if (cubit.selectedSkills.isNotEmpty) ...[
              const SizedBox(height: 12),
              Text("Selected Skills:"),
              Wrap(
                spacing: 8,
                children: cubit.selectedSkills.map((skill) {
                  return Chip(
                    label: Text(skill),
                    deleteIcon: const Icon(Icons.close),
                    onDeleted: () => cubit.removeSkill(skill),
                  );
                }).toList(),
              )
            ],
          ],
        );
      },
    );
  }
}
