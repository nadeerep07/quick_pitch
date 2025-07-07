import 'package:flutter/material.dart';
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
          children: [
            ...cubit.selectedImages.map((file) => Image.file(file, height: 60, width: 60, fit: BoxFit.cover)),
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

  Widget _label(String text) => Padding(
        padding: const EdgeInsets.only(top: 12, bottom: 6),
        child: Text(
          text,
          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
        ),
      );
}
