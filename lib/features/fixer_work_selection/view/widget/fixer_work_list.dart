

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quick_pitch_app/core/config/responsive.dart';
import 'package:quick_pitch_app/features/fixer_work_selection/view/widget/work_card.dart';
import 'package:quick_pitch_app/features/fixer_work_selection/viewmodel/cubit/fixer_work_selection_cubit.dart';
import 'package:quick_pitch_app/features/fixer_work_upload/model/fixer_work_upload_model.dart';

class FixerWorkList extends StatelessWidget {
  final List<FixerWork> works;
  final FixerWork? selectedWork;
  final Responsive res;
  final ThemeData theme;
  final ColorScheme colorScheme;

  const FixerWorkList({
    super.key,
    required this.works,
    required this.selectedWork,
    required this.res,
    required this.theme,
    required this.colorScheme,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: EdgeInsets.all(res.wp(4)),
      itemCount: works.length,
      itemBuilder: (context, index) {
        final work = works[index];
        final isSelected = selectedWork?.id == work.id;

        return WorkCard(
          work: work,
          isSelected: isSelected,
          res: res,
          theme: theme,
          colorScheme: colorScheme,
          onTap: () {
            // ignore: invalid_use_of_protected_member
            context.read<FixerWorkSelectionCubit>().emit(
                  FixerWorkSelectionLoaded(
                    works: works,
                    selectedWork: isSelected ? null : work,
                  ),
                );
          },
        );
      },
    );
  }
}
