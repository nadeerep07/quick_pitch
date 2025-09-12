import 'package:flutter/material.dart';
import 'package:quick_pitch_app/core/config/responsive.dart';
import 'package:quick_pitch_app/features/fixer_work_selection/view/widget/image_placeholder.dart';
import 'package:quick_pitch_app/features/fixer_work_upload/model/fixer_work_upload_model.dart';

class WorkImage extends StatelessWidget {
  final FixerWork work;
  final Responsive res;
  final ColorScheme colorScheme;

  const WorkImage({super.key, 
    required this.work,
    required this.res,
    required this.colorScheme,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: work.images.isNotEmpty
          ? Image.network(
              work.images.first,
              width: res.wp(20),
              height: res.wp(20),
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => ImagePlaceholder(res: res, colorScheme: colorScheme),
            )
          : ImagePlaceholder(res: res, colorScheme: colorScheme),
    );
  }
}
