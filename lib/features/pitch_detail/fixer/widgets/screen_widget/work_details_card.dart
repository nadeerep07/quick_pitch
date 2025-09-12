import 'package:flutter/material.dart';
import 'package:quick_pitch_app/core/config/app_colors.dart';
import 'package:quick_pitch_app/core/config/responsive.dart';
import 'package:quick_pitch_app/features/fixer_work_selection/model/work_request_model.dart';
import 'package:quick_pitch_app/features/pitch_detail/fixer/widgets/screen_widget/detail_row.dart';
import 'package:quick_pitch_app/features/pitch_detail/fixer/widgets/screen_widget/section_card.dart';

class WorkDetailsCard extends StatelessWidget {
  final HireRequest request;

  const WorkDetailsCard({super.key, required this.request});

  @override
  Widget build(BuildContext context) {
    final res = Responsive(context);
    final theme = Theme.of(context);

    return SectionCard(
      title: 'Work Details',
      icon: Icons.work,
      children: [
        DetailRow(
          label: 'Title',
          value: request.workTitle,
          res: res,
          theme: theme,
          isMultiline: true,
        ),
        if (request.workDescription.isNotEmpty)
          DetailRow(
            label: 'Description',
            value: request.workDescription,
            res: res,
            theme: theme,
            isMultiline: true,
          ),
        DetailRow(
          label: 'Amount',
          value: '₹${request.workAmount.toStringAsFixed(0)}',
          res: res,
          theme: theme,
          valueColor: AppColors.primaryColor,
          valueWeight: FontWeight.bold,
        ),
        if (request.workTime.isNotEmpty)
          DetailRow(
            label: 'Duration',
            value: request.workTime,
            res: res,
            theme: theme,
          ),
      ],
    );
  }
}
