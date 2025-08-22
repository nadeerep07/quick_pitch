import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:quick_pitch_app/features/fixer_work_upload/viewmodel/fixer_add_work/cubit/add_work_dialog_cubit.dart';

class SelectedImageItem extends StatelessWidget {
  final ThemeData theme;
  final XFile imageFile;
  final bool isLoading;

  const SelectedImageItem({
    required this.theme,
    required this.imageFile,
    required this.isLoading,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 80,
      height: 80,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Stack(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Image.file(
              File(imageFile.path),
              width: 80,
              height: 80,
              fit: BoxFit.cover,
            ),
          ),
          if (!isLoading)
            Positioned(
              top: 4,
              right: 4,
              child: GestureDetector(
                onTap:
                    () => context
                        .read<AddWorkDialogCubit>()
                        .removeSelectedImage(imageFile),
                child: Container(
                  width: 20,
                  height: 20,
                  decoration: BoxDecoration(
                    color: Colors.red.shade500,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.close_rounded,
                    color: Colors.white,
                    size: 14,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
