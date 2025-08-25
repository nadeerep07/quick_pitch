// Updated FixerWorksPage

import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:quick_pitch_app/features/explore/poster/view/widgets/fixer_work_page/image_loader.dart';
import 'package:quick_pitch_app/features/explore/poster/view/widgets/fixer_work_page/image_placeholder.dart';

class SingleImage extends StatelessWidget {
  final String imageUrl;

  const SingleImage({required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: const BorderRadius.only(
        topLeft: Radius.circular(20),
        topRight: Radius.circular(20),
      ),
      child: Image.network(
        imageUrl,
        fit: BoxFit.cover,
        width: double.infinity,
        height: double.infinity,
        errorBuilder: (context, error, stackTrace) {
          return ImagePlaceholder();
        },
        loadingBuilder: (context, child, loadingProgress) {
          if (loadingProgress == null) return child;
          return ImageLoader();
        },
      ),
    );
  }
}
