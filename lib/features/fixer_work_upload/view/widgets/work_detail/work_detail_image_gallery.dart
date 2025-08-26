import 'package:flutter/material.dart';
import 'package:quick_pitch_app/features/fixer_work_upload/model/fixer_work_upload_model.dart';
import 'package:quick_pitch_app/features/fixer_work_upload/view/widgets/work_detail/work_detail_image_card.dart';

class WorkDetailImageGallery extends StatelessWidget {
  final FixerWork work;
  final ThemeData theme;

  const WorkDetailImageGallery({super.key, required this.work, required this.theme});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Gallery', style: theme.textTheme.titleLarge),
            Text('${work.images.length} images',
              style: theme.textTheme.labelMedium?.copyWith(
                color: theme.colorScheme.onSurface.withOpacity(0.6),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        SizedBox(
          height: 220,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: work.images.length,
            separatorBuilder: (_, __) => const SizedBox(width: 16),
            itemBuilder: (context, index) => WorkDetailImageCard(
              url: work.images[index],
              index: index,
              theme: theme,
            ),
          ),
        ),
      ],
    );
  }
}
