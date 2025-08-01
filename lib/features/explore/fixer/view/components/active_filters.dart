import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quick_pitch_app/features/explore/fixer/viewmodel/cubit/fixer_explore_cubit.dart';

class ActiveFilters extends StatelessWidget {
  const ActiveFilters({super.key});

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<FixerExploreCubit>();
    final state = context.watch<FixerExploreCubit>().state;

    if (!state.showMoreFilters &&
        state.selectedSkills.isEmpty &&
        state.priceRangeStart == state.minBudget &&
        state.priceRangeEnd == state.maxBudget) {
      return const SizedBox();
    }

    return Column(
      children: [
        Wrap(
          spacing: 2,
          runSpacing: 2,
          children: [
            if (state.priceRangeStart != state.minBudget ||
                state.priceRangeEnd != state.maxBudget)
              InputChip(
                label: Text(
                  'Price: \$${state.priceRangeStart.round()}-\$${state.priceRangeEnd.round()}',
                ),
                onDeleted:
                    () => cubit.updatePriceRange(
                      state.minBudget,
                      state.maxBudget,
                    ),
                deleteIcon: const Icon(Icons.close, size: 16),
                backgroundColor: const Color(0xFF4E5AF2).withOpacity(0.1),
              ),
            if (state.selectedSkills.isNotEmpty)
              ...state.selectedSkills.map(
                (skill) => InputChip(
                  label: Text(skill),
                  onDeleted: () => cubit.toggleSkill(skill),
                  deleteIcon: const Icon(Icons.close, size: 16),
                  backgroundColor: const Color(0xFF4E5AF2).withOpacity(0.1),
                ),
              ),
          ],
        ),
      ],
    );
  }
}
