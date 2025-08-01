import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quick_pitch_app/features/explore/fixer/viewmodel/cubit/fixer_explore_cubit.dart';

class FilterChips extends StatelessWidget {
  const FilterChips({super.key});

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<FixerExploreCubit>();
    final state = context.watch<FixerExploreCubit>().state;

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          ...['All', 'Remote', 'On-site'].map(
            (filter) => Padding(
              padding: const EdgeInsets.only(right: 8.0),
              child: FilterChip(
                label: Text(
                  filter,
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                    color:
                        state.selectedFilter == filter
                            ? Colors.white
                            : Colors.grey.shade800,
                  ),
                ),
                selected: state.selectedFilter == filter,
                onSelected: (_) => cubit.updateSelectedFilter(filter),
                selectedColor: const Color(0xFF4E5AF2),
                backgroundColor: Colors.grey.shade100,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: FilterChip(
              label: const Text('More'),
              selected: state.showMoreFilters,
              onSelected: (_) => _showAdvancedFilters(context),
              selectedColor: const Color(0xFF4E5AF2).withOpacity(0.2),
              backgroundColor: Colors.grey.shade100,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            ),
          ),
        ],
      ),
    );
  }

  void _showAdvancedFilters(BuildContext context) {
    final cubit = context.read<FixerExploreCubit>();
    final currentState = cubit.state;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return BlocProvider.value(
          value: cubit,
          child: BlocBuilder<FixerExploreCubit, FixerExploreState>(
            builder: (context, state) {
              return Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      blurRadius: 10,
                      spreadRadius: 5,
                    ),
                  ],
                ),
                padding: const EdgeInsets.all(20),
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Advanced Filters',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                            ),
                          ),
                          Row(
                            children: [
                              TextButton(
                                onPressed: () => cubit.resetFilters(),
                                child: const Text(
                                  'Clear All',
                                  style: TextStyle(color: Color(0xFF4E5AF2)),
                                ),
                              ),
                              IconButton(
                                icon: const Icon(Icons.close),
                                onPressed: () => Navigator.pop(context),
                              ),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      // Price Range
                      Text(
                        'Price Range (\$${state.minBudget.round()}-\$${state.maxBudget.round()})',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 10),
                      RangeSlider(
                        values: RangeValues(
                          state.priceRangeStart,
                          state.priceRangeEnd,
                        ),
                        min: state.minBudget,
                        max: state.maxBudget,
                        divisions:
                            (state.maxBudget - state.minBudget) > 0
                                ? (state.maxBudget - state.minBudget).toInt()
                                : null,
                        activeColor: const Color(0xFF4E5AF2),
                        inactiveColor: Colors.grey.shade300,
                        labels: RangeLabels(
                          '\$${state.priceRangeStart.round()}',
                          '\$${state.priceRangeEnd.round()}',
                        ),
                        onChanged: (RangeValues values) {
                          context.read<FixerExploreCubit>().updatePriceRange(
                            values.start.roundToDouble(),
                            values.end.roundToDouble(),
                          );
                        },
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            '\$${state.minBudget.round()}',
                            style: TextStyle(color: Colors.grey.shade600),
                          ),
                          Text(
                            '\$${state.priceRangeStart.round()} - \$${state.priceRangeEnd.round()}',
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          Text(
                            '\$${state.maxBudget.round()}',
                            style: TextStyle(color: Colors.grey.shade600),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      // Skills Selection
                      Text(
                        'Skills/Specialties',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children:
                            currentState.tasks
                                .expand((task) => task.skills)
                                .toSet()
                                .map(
                                  (skill) => FilterChip(
                                    label: Text(skill),
                                    selected: state.selectedSkills.contains(
                                      skill,
                                    ),
                                    onSelected: (selected) {
                                      context
                                          .read<FixerExploreCubit>()
                                          .toggleSkill(skill);
                                    },
                                    selectedColor: const Color(
                                      0xFF4E5AF2,
                                    ).withOpacity(0.2),
                                    checkmarkColor: const Color(0xFF4E5AF2),
                                  ),
                                )
                                .toList(),
                      ),
                      const SizedBox(height: 20),
                      // Location
                      Text(
                        'Location',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children:
                            [
                                  'Within 5km',
                                  'Within 10km',
                                  'Within 20km',
                                  'Anywhere',
                                ]
                                .map(
                                  (location) => ChoiceChip(
                                    label: Text(location),
                                    selected:
                                        state.selectedLocation == location,
                                    onSelected: (selected) {
                                      context
                                          .read<FixerExploreCubit>()
                                          .updateLocation(location);
                                    },
                                    selectedColor: const Color(0xFF4E5AF2),
                                    labelStyle: TextStyle(
                                      color:
                                          state.selectedLocation == location
                                              ? Colors.white
                                              : Colors.grey.shade800,
                                    ),
                                  ),
                                )
                                .toList(),
                      ),
                      const SizedBox(height: 20),
                      // Deadline
                      Text(
                        'Deadline',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 10),
                      DropdownButtonFormField<String>(
                        value: state.selectedDeadline,
                        items:
                            [
                              'Anytime',
                              'Within 1 week',
                              'Within 2 weeks',
                              'Urgent',
                            ].map((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(value),
                              );
                            }).toList(),
                        onChanged: (newValue) {
                          if (newValue != null) {
                            context.read<FixerExploreCubit>().updateDeadline(
                              newValue,
                            );
                          }
                        },
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 12,
                          ),
                        ),
                      ),
                      const SizedBox(height: 30),
                      // Apply Button
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF4E5AF2),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            padding: const EdgeInsets.symmetric(vertical: 16),
                          ),
                          onPressed: () {
                            Navigator.pop(context);
                            context.read<FixerExploreCubit>().toggleMoreFilters(
                              true,
                            );
                          },
                          child: const Text(
                            'Apply Filters',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                    ],
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }
}
