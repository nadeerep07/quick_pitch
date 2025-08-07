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
    final theme = Theme.of(context);

    await showDialog(
      context: context,
      builder:
          (ctx) => Dialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            child: Padding(
              padding: EdgeInsets.all(res.wp(5)),
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
                    style: theme.textTheme.bodyMedium,
                  ),
                  SizedBox(height: res.hp(2)),
                  TextField(
                    controller: updateController,
                    decoration: InputDecoration(
                      hintText: 'Enter your update...',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      filled: true,
                    ),
                    maxLines: 4,
                    minLines: 3,
                  ),
                  SizedBox(height: res.hp(3)),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton(
                        onPressed: () => Navigator.pop(ctx),
                        child: const Text('Cancel'),
                      ),
                      SizedBox(width: res.wp(3)),
                      ElevatedButton(
                        onPressed: () {
                          context.read<FixerPitchDetailCubit>().addWorkUpdate(
                            currentPitch.id,
                            updateController.text,
                          );
                          Navigator.pop(ctx);
                        },
                        child: const Text('Submit'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
    );
  }