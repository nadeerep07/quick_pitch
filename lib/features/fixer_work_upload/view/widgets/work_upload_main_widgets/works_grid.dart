import 'package:flutter/material.dart';
import 'package:quick_pitch_app/features/fixer_work_upload/model/fixer_work_upload_model.dart';
import 'package:quick_pitch_app/features/fixer_work_upload/view/widgets/work_upload_main_widgets/compact_work_card.dart';
import 'package:quick_pitch_app/features/fixer_work_upload/view/widgets/work_upload_main_widgets/work_card.dart';

class WorksGrid extends StatelessWidget {
  final ThemeData theme;
  final List<FixerWork> works;
  final bool showAll;
  final bool isOwner;

  const WorksGrid({super.key, 
    required this.theme,
    required this.works,
    required this.showAll,
    required this.isOwner,
  });

  @override
  Widget build(BuildContext context) {
    if (showAll) {
      return GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 0.64,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
        ),
        itemCount: works.length,
        itemBuilder: (context, index) {
          return WorkCard(theme: theme, work: works[index], isOwner: isOwner);
        },
      );
    } else {
      return Column(
        children: works
            .asMap()
            .entries
            .map((entry) => Padding(
                  padding: EdgeInsets.only(
                    bottom: entry.key < works.length - 1 ? 16 : 0,
                  ),
                  child: CompactWorkCard(
                    theme: theme,
                    work: entry.value,
                    isOwner: isOwner,
                  ),
                ))
            .toList(),
      );
    }
  }
}
