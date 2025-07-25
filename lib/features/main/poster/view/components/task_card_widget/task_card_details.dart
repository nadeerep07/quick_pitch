import 'package:flutter/material.dart';
import 'package:quick_pitch_app/core/config/responsive.dart';
import 'package:quick_pitch_app/features/main/poster/view/components/task_card_widget/task_card_fixer_info.dart';
import 'package:quick_pitch_app/features/main/poster/view/components/task_card_widget/task_card_title.dart';

class TaskCardDetails extends StatelessWidget {
  const TaskCardDetails({
    super.key,
    required this.res,
    required this.title,
    required this.fixerName,
    required this.context,
  });

  final Responsive res;
  final String title;
  final String fixerName;
  final BuildContext context;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(res.wp(3)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TaskCardTitle(title: title, context: context),
          SizedBox(height: res.hp(1.2)),
          TaskCardFixerInfo(res: res, fixerName: fixerName, context: context),
        ],
      ),
    );
  }
}
