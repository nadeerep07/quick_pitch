import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:quick_pitch_app/features/task_post/poster_task/viewmodel/cubit/task_post_cubit.dart';

class TaskImageUploader extends StatelessWidget {
  final TaskPostCubit cubit;
  const TaskImageUploader({super.key, required this.cubit});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _label("Upload Images"),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            // Show uploaded image URLs
            ...List.generate(cubit.uploadedImageUrls.length, (index) {
              final url = cubit.uploadedImageUrls[index];
              return Stack(
                children: [
                  CachedNetworkImage(
                    imageUrl: url,
                    height: 60,
                    width: 60,
                    fit: BoxFit.cover,
                    placeholder: (context, _) => const CircularProgressIndicator(),
                    errorWidget: (context, _, __) => const Icon(Icons.broken_image),
                  ),
                  _deleteIcon(() {
                    cubit.removeUploadedImageAt(index);
                  }),
                ],
              );
            }),

            // Show selected local images
            ...List.generate(cubit.selectedImages.length, (index) {
              final file = cubit.selectedImages[index];
              return Stack(
                children: [
                  Image.file(
                    file,
                    height: 60,
                    width: 60,
                    fit: BoxFit.cover,
                  ),
                  _deleteIcon(() {
                    cubit.removeSelectedImageAt(index);
                  }),
                ],
              );
            }),

            // Add Image Button
            GestureDetector(
              onTap: cubit.pickImages,
              child: Container(
                height: 60,
                width: 60,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey.shade400),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(Icons.add_a_photo, size: 20),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _deleteIcon(VoidCallback onPressed) => Positioned(
        top: -6,
        right: -6,
        child: GestureDetector(
          onTap: onPressed,
          child: Container(
            padding: const EdgeInsets.all(4),
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.black54,
            ),
            child: const Icon(Icons.close, size: 14, color: Colors.white),
          ),
        ),
      );

  Widget _label(String text) => Padding(
        padding: const EdgeInsets.only(top: 12, bottom: 6),
        child: Text(
          text,
          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
        ),
      );
}
