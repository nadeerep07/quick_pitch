// Updated FixerWorksPage

import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:quick_pitch_app/features/explore/poster/view/widgets/fixer_work_page/image_carousel.dart';
import 'package:quick_pitch_app/features/explore/poster/view/widgets/fixer_work_page/single_image.dart';

class WorkImageSection extends StatelessWidget {
  final List<String> images;

  const WorkImageSection({required this.images});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 220,
      width: double.infinity,
      child: Stack(
        children: [
          images.length == 1
              ? SingleImage(imageUrl: images.first)
              : ImageCarousel(images: images),
          
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              height: 80,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.transparent,
                    Colors.black.withOpacity(0.7),
                  ],
                ),
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
