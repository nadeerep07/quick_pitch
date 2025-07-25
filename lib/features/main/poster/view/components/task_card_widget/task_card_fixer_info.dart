import 'package:flutter/material.dart';
import 'package:quick_pitch_app/core/config/responsive.dart';
import 'package:quick_pitch_app/features/main/poster/view/components/task_card_widget/task_card_fixer_avatar.dart';
import 'package:quick_pitch_app/features/main/poster/view/components/task_card_widget/task_card_fixer_name.dart';

class TaskCardFixerInfo extends StatelessWidget {
  const TaskCardFixerInfo({
    super.key,
    required this.res,
    required this.fixerName,
    required this.context,
  });

  final Responsive res;
  final String fixerName;
  final BuildContext context;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        TaskCardFixerAvatar(context: context),
        SizedBox(width: res.wp(2)),
        TaskCardFixerName(fixerName: fixerName, context: context),
        const Spacer(),
        Icon(
          Icons.chevron_right_rounded,
          color: Colors.grey[400],
          size: 20,
        ),
      ],
    );
  }
}
