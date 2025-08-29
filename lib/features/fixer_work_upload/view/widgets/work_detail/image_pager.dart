import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quick_pitch_app/features/fixer_work_upload/viewmodel/cubit/cubit/image_full_screen_dialog_dart_cubit.dart';

/// ---------------------------
/// PageView (swipeable images)
/// ---------------------------
class ImagePager extends StatelessWidget {
  final PageController controller;
  final List<String> images;

  const ImagePager({
    required this.controller,
    required this.images,
  });

  @override
  Widget build(BuildContext context) {
    return PageView.builder(
      controller: controller,
      onPageChanged: (index) =>
          context.read<ImageIndexCubit>().change(index),
      itemCount: images.length,
      itemBuilder: (context, index) {
        return InteractiveViewer(
          minScale: 0.5,
          maxScale: 3.0,
          child: Center(
            child: Hero(
              tag: 'work_image_$index',
              child: CachedNetworkImage(
                imageUrl: images[index],
                fit: BoxFit.contain,
                placeholder: (context, url) => const Center(
                  child: CircularProgressIndicator(color: Colors.white),
                ),
                errorWidget: (context, url, error) => const Center(
                  child: Icon(
                    Icons.broken_image_outlined,
                    size: 80,
                    color: Colors.white54,
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

