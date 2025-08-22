import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:quick_pitch_app/features/fixer_work_upload/model/fixer_work_upload_model.dart';
import 'package:quick_pitch_app/features/fixer_work_upload/view/widgets/work_detail/dialog_content.dart';
import 'package:quick_pitch_app/features/fixer_work_upload/view/widgets/work_detail/work_detail_detail_card.dart';

class WorkDetailWorkDetails extends StatelessWidget {
  final FixerWork work;
  final ThemeData theme;

  const WorkDetailWorkDetails({required this.work, required this.theme});

  @override

  Widget build(BuildContext context) {
    final dateFormatter = DateFormat('MMM dd, yyyy');
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Details', style: theme.textTheme.titleLarge),
        const SizedBox(height: 20),
        WorkDetailDetailCard(label: 'Description', value: work.description, icon: Icons.description_outlined, theme: theme),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(child: WorkDetailDetailCard(label: 'Duration', value: work.time, icon: Icons.access_time, theme: theme)),
            const SizedBox(width: 16),
            Expanded(child: WorkDetailDetailCard(label: 'Date Added', value: dateFormatter.format(work.createdAt), icon: Icons.calendar_today, theme: theme)),
          ],
        ),
      ],
    );
  }
}
