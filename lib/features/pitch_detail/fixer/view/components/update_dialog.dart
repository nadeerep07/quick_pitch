import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quick_pitch_app/core/config/responsive.dart';
import 'package:quick_pitch_app/features/pitch_detail/fixer/viewmodel/cubit/fixer_pitch_detail_cubit.dart';
import 'package:quick_pitch_app/features/task_pitching/model/pitch_model.dart';

Future<void> showUpdateDialog(
  BuildContext context,
  PitchModel currentPitch,
  Responsive res,
) async {
  final updateController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  final fixerCubit = context.read<FixerPitchDetailCubit>();

  await showDialog(
    context: context,
    barrierDismissible: false,
    builder: (ctx) {
      return BlocProvider.value(
        value: fixerCubit,
        child: BlocListener<FixerPitchDetailCubit, FixerPitchDetailState>(
          listener: (dialogContext, state) {
            if (state is FixerPitchDetailUpdateSuccess) {
              Navigator.pop(dialogContext);
              ScaffoldMessenger.of(dialogContext).showSnackBar(
                SnackBar(content: Text(state.message)),
              );
            } else if (state is FixerPitchDetailUpdateFailure) {
              ScaffoldMessenger.of(dialogContext).showSnackBar(
                SnackBar(content: Text(state.error), backgroundColor: Colors.red),
              );
            }
          },
          child: BlocBuilder<FixerPitchDetailCubit, FixerPitchDetailState>(
            builder: (dialogContext, state) {
              final theme = Theme.of(dialogContext);
              final isLoading = state is FixerPitchDetailUpdateLoading;

              return Dialog(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                elevation: 4,
                child: Padding(
                  padding: EdgeInsets.all(res.wp(4)),
                  child: Form(
                    key: formKey,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Add Work Update',
                          style: theme.textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        SizedBox(height: res.hp(2)),
                        Text(
                          'Share your progress with the poster:',
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: Colors.grey[600],
                          ),
                        ),
                        SizedBox(height: res.hp(2)),
                        TextFormField(
                          controller: updateController,
                          decoration: InputDecoration(
                            hintText: 'Enter your update...',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide(color: Colors.grey[400]!),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide(color: Colors.grey[400]!),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide(color: theme.primaryColor),
                            ),
                            filled: true,
                            fillColor: Colors.grey[100],
                            contentPadding: EdgeInsets.all(res.wp(3)),
                          ),
                          maxLines: 4,
                          minLines: 3,
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return 'Please enter an update';
                            }
                            return null;
                          },
                        ),
                        SizedBox(height: res.hp(3)),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            TextButton(
                              onPressed: isLoading ? null : () => Navigator.pop(ctx),
                              style: TextButton.styleFrom(
                                foregroundColor: Colors.grey[700],
                                padding: EdgeInsets.symmetric(
                                  horizontal: res.wp(4),
                                  vertical: res.hp(1),
                                ),
                              ),
                              child: const Text('CANCEL'),
                            ),
                            SizedBox(width: res.wp(3)),
                            ElevatedButton(
                              onPressed: isLoading
                                  ? null
                                  : () {
                                      if (formKey.currentState!.validate()) {
                                        dialogContext
                                            .read<FixerPitchDetailCubit>()
                                            .addWorkUpdate(
                                              currentPitch.id,
                                              updateController.text,
                                            );
                                      }
                                      Navigator.pop(context);
                                    },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: theme.primaryColor,
                                foregroundColor: Colors.white,
                                padding: EdgeInsets.symmetric(
                                  horizontal: res.wp(4),
                                  vertical: res.hp(1),
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                              child: isLoading
                                  ? SizedBox(
                                      width: res.wp(4),
                                      height: res.wp(4),
                                      child: const CircularProgressIndicator(
                                        color: Colors.white,
                                        strokeWidth: 2,
                                      ),
                                    )
                                  : const Text('SUBMIT'),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      );
    },
  );
}
