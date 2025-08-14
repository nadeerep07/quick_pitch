import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quick_pitch_app/core/config/responsive.dart';
import 'package:quick_pitch_app/features/pitch_detail/fixer/viewmodel/cubit/fixer_pitch_detail_cubit.dart';
import 'package:quick_pitch_app/features/task_pitching/model/pitch_model.dart';

Future<void> showCompletionDialog(
  BuildContext context,
  Responsive res,
  PitchModel currentPitch,
) async {
  final controller = TextEditingController();
  final formKey = GlobalKey<FormState>();
  bool isLoading = false;

  // Get the cubit from the current context
  final fixerCubit = context.read<FixerPitchDetailCubit>();

  await showDialog(
    context: context,
    barrierDismissible: false,
    builder: (ctx) => StatefulBuilder(
      builder: (dialogContext, setState) {
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
                    'Mark Task as Completed',
                    style: TextStyle(
                      fontSize: res.wp(5),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: res.hp(2)),
                  Text(
                    'Add any completion notes for the poster:',
                    style: TextStyle(
                      fontSize: res.wp(4),
                      color: Colors.grey[600],
                    ),
                  ),
                  SizedBox(height: res.hp(2)),
                  TextFormField(
                    controller: controller,
                    decoration: InputDecoration(
                      hintText: 'Enter completion notes...',
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
                        borderSide: BorderSide(
                          color: Theme.of(dialogContext).primaryColor,
                        ),
                      ),
                      filled: true,
                      fillColor: Colors.grey[100],
                      contentPadding: EdgeInsets.all(res.wp(3)),
                    ),
                    maxLines: 4,
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Please enter completion notes';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: res.hp(3)),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton(
                        onPressed:
                            isLoading ? null : () => Navigator.pop(ctx),
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
                            : () async {
                                if (formKey.currentState!.validate()) {
                                  setState(() => isLoading = true);
                                  await fixerCubit.markAsCompleted(
                                    currentPitch.id,
                                    controller.text,
                                  );
                                  setState(() => isLoading = false);
                                  Navigator.pop(ctx);
                                }
                              },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Theme.of(dialogContext).primaryColor,
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
                                child: CircularProgressIndicator(
                                  color: Colors.white,
                                  strokeWidth: 2,
                                ),
                              )
                            : const Text('COMPLETE'),
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
  );
}
