import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quick_pitch_app/core/config/app_colors.dart';
import 'package:quick_pitch_app/features/explore/fixer/view/widgets/apply_button.dart';
import 'package:quick_pitch_app/features/explore/fixer/view/widgets/deadline_section.dart';
import 'package:quick_pitch_app/features/explore/fixer/view/widgets/header_section.dart';
import 'package:quick_pitch_app/features/explore/fixer/view/widgets/location_section.dart';
import 'package:quick_pitch_app/features/explore/fixer/view/widgets/price_range_section.dart';
import 'package:quick_pitch_app/features/explore/fixer/view/widgets/skills_section.dart';
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
            (filter) => _buildFilterChip(
              context,
              label: filter,
              selected: state.selectedFilter == filter,
              onTap: () => cubit.updateSelectedFilter(filter),
            ),
          ),
          _buildFilterChip(
            context,
            label: 'More',
            selected: state.showMoreFilters,
            onTap: () => _showAdvancedFilters(context),
            isMore: true,
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChip(
    BuildContext context, {
    required String label,
    required bool selected,
    required VoidCallback onTap,
    bool isMore = false,
  }) {
    return Padding(
      padding: const EdgeInsets.only(right: 8.0),
      child: FilterChip(
        label: Text(
          label,
          style: TextStyle(
            fontWeight: FontWeight.w500,
            color: selected ? Colors.white : Colors.grey.shade800,
          ),
        ),
        selected: selected,
        onSelected: (_) => onTap(),
        selectedColor: isMore
            ? AppColors.primary.withValues(alpha: .3)
            : AppColors.primaryColor,
        backgroundColor: Colors.grey.shade100,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      ),
    );
  }

  void _showAdvancedFilters(BuildContext context) {
    final cubit = context.read<FixerExploreCubit>();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => BlocProvider.value(
        value: cubit,
        child: BlocBuilder<FixerExploreCubit, FixerExploreState>(
          builder: (context, state) {
            return Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.2),
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
                    HeaderSection(onClear: cubit.resetFilters),
                    const SizedBox(height: 20),
                    PriceRangeSection(),
                    const SizedBox(height: 20),
                    SkillsSection(),
                    const SizedBox(height: 20),
                    LocationSection(),
                    const SizedBox(height: 20),
                    DeadlineSection(),
                    const SizedBox(height: 30),
                    ApplyButton(),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
