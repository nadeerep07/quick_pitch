// Updated FixerWorksPage

import 'package:flutter/material.dart';
import 'package:quick_pitch_app/features/explore/poster/view/screen/fixer_work_page.dart';
import 'package:quick_pitch_app/features/explore/poster/view/widgets/fixer_work_page/metadata_item.dart';
import 'package:quick_pitch_app/features/fixer_work_upload/model/fixer_work_upload_model.dart';

class WorkMetadata extends StatelessWidget {
  final FixerWork work;

  const WorkMetadata({required this.work});

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inDays == 0) {
      return 'Today';
    } else if (difference.inDays == 1) {
      return 'Yesterday';
    } else if (difference.inDays < 7) {
      return '${difference.inDays} days ago';
    } else if (difference.inDays < 30) {
      final weeks = (difference.inDays / 7).floor();
      return '$weeks week${weeks > 1 ? 's' : ''} ago';
    } else {
      return '${date.day}/${date.month}/${date.year}';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        if (work.time.isNotEmpty) ...[
          MetadataItem(
            icon: Icons.schedule_rounded,
            text: work.time,
            color: Colors.orange,
          ),
          const SizedBox(width: 20),
        ],
        MetadataItem(
          icon: Icons.calendar_today_rounded,
          text: _formatDate(work.createdAt),
          color: Colors.blue,
        ),
      ],
    );
  }
}
