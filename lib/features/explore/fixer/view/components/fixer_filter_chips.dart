import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quick_pitch_app/core/config/responsive.dart';
import 'package:quick_pitch_app/features/explore/fixer/viewmodel/cubit/explore_screen_cubit.dart';

class FixerFilterChips extends StatelessWidget {
  const FixerFilterChips({
    super.key,
    required this.context,
  });

  final BuildContext context;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: Responsive(context).hp(5.2),
      child: BlocBuilder<ExploreScreenCubit, ExploreScreenState>(
        builder: (context, state) {
          final defaultFilters = ['All', 'On-site', 'Remote'];
          final showExtra = !defaultFilters.contains(state.selectedFilter);
          final filters = showExtra ? [...defaultFilters, state.selectedFilter] : defaultFilters;

          return ListView(
            scrollDirection: Axis.horizontal,
            children: [
              const SizedBox(width: 8),
              ...filters.map((filter) {
                final selected = state.selectedFilter == filter;
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4.0),
                  child: ChoiceChip(
                    label: Text(filter),
                    selected: selected,
                    onSelected: (_) =>
                        context.read<ExploreScreenCubit>().updateFilter(selectedFilter: filter),
                    selectedColor: Colors.black87,
                    backgroundColor: Colors.white.withValues(alpha: .85),
                    labelStyle: TextStyle(
                      color: selected ? Colors.white : Colors.black87,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                );
              }),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4.0),
                child: ActionChip(
                  label: const Row(
                    children: [
                      Icon(Icons.filter_alt, size: 18),
                      SizedBox(width: 4),
                      Text('More'),
                    ],
                  ),
                  onPressed: () => context.read<ExploreScreenCubit>().openFilterBottomSheet(context),
                  backgroundColor: Colors.white.withValues(alpha: .85),
                  labelStyle: const TextStyle(fontWeight: FontWeight.w500),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
