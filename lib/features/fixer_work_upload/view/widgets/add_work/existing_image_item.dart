import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quick_pitch_app/features/fixer_work_upload/viewmodel/fixer_add_work/cubit/add_work_dialog_cubit.dart';

class ExistingImageItem extends StatelessWidget {
  final ThemeData theme;
  final String imageUrl;
  final bool isLoading;

  const ExistingImageItem({super.key, 
    required this.theme,
    required this.imageUrl,
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
            child: Image.network(
              imageUrl,
              width: 80,
              height: 80,
              fit: BoxFit.cover,
              errorBuilder:
                  (context, error, stackTrace) => Container(
                    color: Colors.grey.shade200,
                    child: Icon(
                      Icons.error_outline,
                      color: Colors.grey.shade500,
                      size: 24,
                    ),
                  ),
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
                        .removeExistingImage(imageUrl),
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
