import 'package:flutter/material.dart';
import 'package:quick_pitch_app/features/fixer_work_upload/model/fixer_work_upload_model.dart';
import 'package:quick_pitch_app/features/fixer_work_upload/view/widgets/work_detail/dialog_content.dart';
import 'package:quick_pitch_app/features/fixer_work_upload/view/widgets/work_detail/work_detail_image_gallery.dart';
import 'package:quick_pitch_app/features/fixer_work_upload/view/widgets/work_detail/work_detail_work_details.dart';

class WorkDetailContent extends StatelessWidget {
  final FixerWork work;
  final ThemeData theme;

  const WorkDetailContent({required this.work, required this.theme});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (work.images.isNotEmpty) ...[
            WorkDetailImageGallery(work: work, theme: theme),
            const SizedBox(height: 32),
          ],
         WorkDetailWorkDetails(work: work, theme: theme),
        ],
      ),
    );
  }
}