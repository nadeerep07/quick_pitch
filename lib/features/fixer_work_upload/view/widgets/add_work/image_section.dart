import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quick_pitch_app/features/fixer_work_upload/view/widgets/add_work/empty_image_placeholder.dart';
import 'package:quick_pitch_app/features/fixer_work_upload/view/widgets/add_work/image_list.dart';
import 'package:quick_pitch_app/features/fixer_work_upload/viewmodel/fixer_add_work/cubit/add_work_dialog_cubit.dart';
import 'package:quick_pitch_app/features/fixer_work_upload/viewmodel/fixer_add_work/cubit/add_work_dialog_state.dart';
import 'package:quick_pitch_app/features/fixer_work_upload/viewmodel/fixer_work/bloc/fixer_work_bloc.dart';

class AddImageSection extends StatelessWidget {
  final ThemeData theme;
  final VoidCallback onPickImages;

  const AddImageSection({
    required this.theme,
    required this.onPickImages,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AddWorkDialogCubit, AddWorkDialogState>(
      builder: (context, dialogState) {
        return BlocBuilder<FixerWorksBloc, FixerWorksState>(
          builder: (context, worksState) {
            final isLoading = worksState is FixerWorksLoading;

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Work Images',
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: Colors.grey.shade800,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  '${dialogState.totalImages} of 5 images selected',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: Colors.grey.shade600,
                  ),
                ),
                const SizedBox(height: 16),
                if (dialogState.totalImages > 0)
                  ImageList(
                    theme: theme,
                    dialogState: dialogState,
                    isLoading: isLoading,
                    onPickImages: onPickImages,
                  )
                else
                  EmptyImagePlaceholder(
                    theme: theme,
                    isLoading: isLoading,
                    onPickImages: onPickImages,
                  ),
              ],
            );
          },
        );
      },
    );
  }
}
