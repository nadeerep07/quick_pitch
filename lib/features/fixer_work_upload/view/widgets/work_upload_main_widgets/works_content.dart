import 'package:flutter/material.dart';
import 'package:quick_pitch_app/features/fixer_work_upload/model/fixer_work_upload_model.dart';
import 'package:quick_pitch_app/features/fixer_work_upload/view/widgets/work_upload_main_widgets/empty_state.dart';
import 'package:quick_pitch_app/features/fixer_work_upload/view/widgets/work_upload_main_widgets/show_less_button.dart';
import 'package:quick_pitch_app/features/fixer_work_upload/view/widgets/work_upload_main_widgets/view_more_button.dart';
import 'package:quick_pitch_app/features/fixer_work_upload/view/widgets/work_upload_main_widgets/works_grid.dart';

class WorksContent extends StatelessWidget {
  final ThemeData theme;
  final List<FixerWork> works;
  final bool showAll;
  final bool isOwner;
  final VoidCallback onToggleView;

  const WorksContent({
    required this.theme,
    required this.works,
    required this.showAll,
    required this.isOwner,
    required this.onToggleView,
  });

  @override
  Widget build(BuildContext context) {
    if (works.isEmpty) {
      return EmptyState(theme: theme, isOwner: isOwner);
    }

    final displayWorks = showAll ? works : works.take(3).toList();
    final hasMore = works.length > 3;

    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '${works.length} ${works.length == 1 ? 'Project' : 'Projects'}',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurface.withOpacity(0.7),
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 16),
          WorksGrid(
            theme: theme,
            works: displayWorks,
            showAll: showAll,
            isOwner: isOwner,
          ),
          if (hasMore && !showAll) ...[
            const SizedBox(height: 20),
            ViewMoreButton(
              theme: theme,
              count: works.length - 3,
              onPressed: onToggleView,
            ),
          ],
          if (showAll && hasMore) ...[
            const SizedBox(height: 20),
            ShowLessButton(theme: theme, onPressed: onToggleView),
          ],
        ],
      ),
    );
  }
}
