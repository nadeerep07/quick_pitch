import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quick_pitch_app/core/config/app_colors.dart';
import 'package:quick_pitch_app/features/explore/fixer/viewmodel/cubit/fixer_explore_cubit.dart';

class LocationSection extends StatelessWidget {
  const LocationSection({super.key});

  @override
  Widget build(BuildContext context) {
    final state = context.watch<FixerExploreCubit>().state;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Location',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 10),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: state.popularLocations
              .map(
                (location) => ChoiceChip(
                  label: Text(location),
                  selected: state.selectedLocation == location,
                  onSelected: (selected) {
                    context.read<FixerExploreCubit>().updateLocation(
                          selected && state.selectedLocation != location
                              ? location
                              : null,
                        );
                  },
                  selectedColor: AppColors.primaryColor,
                  labelStyle: TextStyle(
                    color: state.selectedLocation == location
                        ? Colors.white
                        : Colors.grey.shade800,
                  ),
                ),
              )
              .toList(),
        ),
      ],
    );
  }
}
