import 'package:flutter/material.dart';
import 'package:quick_pitch_app/core/config/responsive.dart';
import 'package:quick_pitch_app/features/fixer_work_selection/model/work_request_model.dart';
import 'package:quick_pitch_app/features/pitch_detail/fixer/widgets/screen_widget/detail_row.dart';
import 'package:quick_pitch_app/features/pitch_detail/fixer/widgets/screen_widget/section_card.dart';

class ClientDetailsCard extends StatelessWidget {
  final HireRequest request;

  const ClientDetailsCard({super.key, required this.request});

  @override
  Widget build(BuildContext context) {
    final res = Responsive(context);
    final theme = Theme.of(context);

    return SectionCard(
      title: 'Client Details',
      icon: Icons.person,
      children: [
        DetailRow(
          label: 'Name',
          value: request.posterName,
          res: res,
          theme: theme,
          leadingWidget: CircleAvatar(
            radius: res.wp(4),
            backgroundImage: request.posterImage.isNotEmpty
                ? NetworkImage(request.posterImage)
                : null,
            child: request.posterImage.isEmpty
                ? Icon(Icons.person, size: res.wp(4))
                : null,
          ),
        ),
        DetailRow(
          label: 'Request Date',
          value: _formatDate(request.createdAt),
          res: res,
          theme: theme,
        ),
        if (request.message?.isNotEmpty ?? false)
          DetailRow(
            label: 'Message',
            value: request.message!,
            res: res,
            theme: theme,
            isMultiline: true,
          ),
      ],
    );
  }
}
String _formatDate(DateTime date) {
  return '${date.day}/${date.month}/${date.year}';
}