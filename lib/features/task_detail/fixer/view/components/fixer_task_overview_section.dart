import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:quick_pitch_app/core/config/responsive.dart';
import 'package:quick_pitch_app/features/poster_task/model/task_post_model.dart';
import 'package:quick_pitch_app/features/task_detail/fixer/view/components/fixer_detail_go_to_location.dart';
import 'package:quick_pitch_app/features/task_detail/fixer/view/components/fixer_detail_info_card.dart';
import 'package:quick_pitch_app/features/task_detail/fixer/view/components/fixer_detail_info_row.dart';

class FixerTaskOverviewSection extends StatelessWidget {
  final TaskPostModel task;
  final Responsive res;

  const FixerTaskOverviewSection({
    super.key,
    required this.task,
    required this.res,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        FixerDetailInfoCard(
          res: res,
          child: FixerDetailInfoRow(
            label: 'Budget:',
            value: '₹${task.budget}',
            res: res,
          ),
        ),
        FixerDetailInfoCard(
          res: res,
          child: FixerDetailInfoRow(
            label: 'Preferred Time:',
            value: task.preferredTime,
            res: res,
          ),
        ),
        FixerDetailInfoCard(
          res: res,
          child: FixerDetailInfoRow(
            label: 'Deadline:',
            value: DateFormat.yMMMd().format(task.deadline),
            res: res,
          ),
        ),
        if(task.location != null)
        FixerDetailInfoCard(
          res: res,
          child: FixerDetailGoToLocation(
            context: context,
            label: 'Location:',
            location: task.location ?? 'Remote' ,
            res: res,
          ),
        ),
        FixerDetailInfoCard(
          res: res,
          child: Text(
            task.description,
            style: TextStyle(fontSize: res.sp(13)),
          ),
        ),
        FixerDetailInfoCard(
          res: res,
          child: FixerDetailInfoRow(
            label: 'Work Type:',
            value: task.workType,
            res: res,
          ),
        ),
       
      ],
    );
  }
}
