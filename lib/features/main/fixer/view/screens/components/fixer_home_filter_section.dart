import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quick_pitch_app/core/config/app_colors.dart';
import 'package:quick_pitch_app/core/config/responsive.dart';
import 'package:quick_pitch_app/features/main/fixer/viewmodel/cubit/fixer_home_cubit.dart';

class FixerHomeFilterSection extends StatelessWidget {
  const FixerHomeFilterSection({
    super.key,
    required this.res,
  });

  final Responsive res;

  @override
  Widget build(BuildContext context) {
  return BlocBuilder<FixerHomeCubit, FixerHomeState>(
    builder: (context, state) {
      if (state is! FixerHomeLoaded) return const SizedBox.shrink();

      final skills = state.userProfile.fixerData?.skills ?? [];
      if (skills.isEmpty) return const SizedBox.shrink();

      final filterOptions = ['All Tasks', ...skills.take(4)];
      final selectedFilters = state.selectedFilters;

      return Container(
        margin: EdgeInsets.symmetric(horizontal: res.wp(5)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Filter by Skills',
              style: TextStyle(
                fontSize: res.sp(14),
                fontWeight: FontWeight.w600,
                color: const Color(0xFF475569),
              ),
            ),
            SizedBox(height: res.hp(1)),
            SizedBox(
              height: res.hp(5),
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: filterOptions.length,
                separatorBuilder: (_, __) => SizedBox(width: res.wp(2)),
                itemBuilder: (context, index) {
                  final filter = filterOptions[index];
                  final isSelected = selectedFilters.contains(filter) ||
                      (filter == 'All Tasks' && selectedFilters.isEmpty);

                  return GestureDetector(
                    onTap: () {
                      context.read<FixerHomeCubit>().toggleFilter(filter);
                    },
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: res.wp(4),
                        vertical: res.hp(1),
                      ),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? AppColors.primaryColor
                            : Colors.white.withOpacity(0.9),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: isSelected
                              ? const Color(0xFF3B82F6)
                              : const Color(0xFFE2E8F0),
                        ),
                        boxShadow: const [
                          BoxShadow(
                            color: Color(0x08000000),
                            blurRadius: 4,
                            offset: Offset(0, 1),
                          ),
                        ],
                      ),
                      child: Text(
                        filter,
                        style: TextStyle(
                          fontSize: res.sp(12),
                          fontWeight: FontWeight.w500,
                          color: isSelected
                              ? Colors.white
                              : const Color(0xFF475569),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      );
    },
  );
}
}
