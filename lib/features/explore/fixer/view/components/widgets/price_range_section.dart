import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quick_pitch_app/core/config/app_colors.dart';
import 'package:quick_pitch_app/features/explore/fixer/viewmodel/cubit/fixer_explore_cubit.dart';

class PriceRangeSection extends StatelessWidget {
  const PriceRangeSection({super.key});

  @override
  Widget build(BuildContext context) {
    final state = context.watch<FixerExploreCubit>().state;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Price Range (\$${state.minBudget.round()} - \$${state.maxBudget.round()})',
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 10),
        RangeSlider(
          values: RangeValues(state.priceRangeStart, state.priceRangeEnd),
          min: state.minBudget,
          max: state.maxBudget,
          divisions: (state.maxBudget - state.minBudget) > 0
              ? (state.maxBudget - state.minBudget).toInt()
              : null,
          activeColor: AppColors.primaryColor,
          inactiveColor: Colors.grey.shade300,
          labels: RangeLabels(
            '\$${state.priceRangeStart.round()}',
            '\$${state.priceRangeEnd.round()}',
          ),
          onChanged: (values) {
            context.read<FixerExploreCubit>().updatePriceRange(
                  values.start.roundToDouble(),
                  values.end.roundToDouble(),
                );
          },
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('\$${state.minBudget.round()}',
                style: TextStyle(color: Colors.grey.shade600)),
            Text(
              '\$${state.priceRangeStart.round()} - \$${state.priceRangeEnd.round()}',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            Text('\$${state.maxBudget.round()}',
                style: TextStyle(color: Colors.grey.shade600)),
          ],
        ),
      ],
    );
  }
}
