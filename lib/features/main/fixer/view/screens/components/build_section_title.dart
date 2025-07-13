import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quick_pitch_app/core/config/responsive.dart';
import 'package:quick_pitch_app/features/main/fixer/viewmodel/cubit/section_filter_cubit.dart';

class BuildSectionTitle extends StatefulWidget {
  const BuildSectionTitle({
    super.key,
    required this.res,
    required this.title,
    required this.filters,
  });

  final Responsive res;
  final String title;
  final List<String> filters;

  @override
  State<BuildSectionTitle> createState() => _BuildSectionTitleState();
}

class _BuildSectionTitleState extends State<BuildSectionTitle> {
  Set<String> selectedFilters = {};

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Section Title Row
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              widget.title,
              style: TextStyle(
                fontSize: widget.res.sp(18),
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),

        // Filter Chip List
        BlocBuilder<SectionFilterCubit, Set<String>>(
          builder: (context, selectedFilters) {
            
            return SizedBox(
              height: widget.res.hp(5),
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: widget.filters.length,
                separatorBuilder: (_, __) => SizedBox(width: 8),
                itemBuilder: (context, index) {
                  final filter = widget.filters[index];
                  final isSelected = selectedFilters.contains(filter);

                  return FilterChip(
                    label: Text(filter),
                    selected: isSelected,
                    onSelected: (_) {
                      setState(() {
                        context.read<SectionFilterCubit>().toggleFilter(filter);
                      });
                    },
                  );
                },
              ),
            );
          },
        ),
      ],
    );
  }
}
