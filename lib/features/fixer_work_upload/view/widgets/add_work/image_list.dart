import 'package:flutter/material.dart';
import 'package:quick_pitch_app/features/fixer_work_upload/view/widgets/add_work/add_more_button.dart';
import 'package:quick_pitch_app/features/fixer_work_upload/view/widgets/add_work/existing_image_item.dart';
import 'package:quick_pitch_app/features/fixer_work_upload/view/widgets/add_work/selected_image_item.dart';
import 'package:quick_pitch_app/features/fixer_work_upload/viewmodel/fixer_add_work/cubit/add_work_dialog_state.dart';

class ImageList extends StatelessWidget {
  final ThemeData theme;
  final AddWorkDialogState dialogState;
  final bool isLoading;
  final VoidCallback onPickImages;

  const ImageList({
    required this.theme,
    required this.dialogState,
    required this.isLoading,
    required this.onPickImages,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 80,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount:
            dialogState.totalImages + (dialogState.totalImages < 5 ? 1 : 0),
        separatorBuilder: (context, index) => const SizedBox(width: 12),
        itemBuilder: (context, index) {
          if (index == dialogState.totalImages && dialogState.totalImages < 5) {
            return AddMoreButton(
              theme: theme,
              isLoading: isLoading,
              onPickImages: onPickImages,
            );
          }

          if (index < dialogState.existingImages.length) {
            return ExistingImageItem(
              theme: theme,
              imageUrl: dialogState.existingImages[index],
              isLoading: isLoading,
            );
          } else {
            final fileIndex = index - dialogState.existingImages.length;
            return SelectedImageItem(
              theme: theme,
              imageFile: dialogState.selectedImages[fileIndex],
              isLoading: isLoading,
            );
          }
        },
      ),
    );
  }
}
