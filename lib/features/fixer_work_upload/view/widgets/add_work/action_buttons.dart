import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quick_pitch_app/features/fixer_work_upload/model/fixer_work_upload_model.dart';
import 'package:quick_pitch_app/features/fixer_work_upload/viewmodel/fixer_work/bloc/fixer_work_bloc.dart';

class ActionButtons extends StatelessWidget {
  final ThemeData theme;
  final FixerWork? editingWork;
  final VoidCallback onCancel;
  final VoidCallback onSubmit;

  const ActionButtons({super.key, 
    required this.theme,
    required this.editingWork,
    required this.onCancel,
    required this.onSubmit,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FixerWorksBloc, FixerWorksState>(
      builder: (context, state) {
        final isLoading = state is FixerWorksLoading;

        return Row(
          children: [
            Expanded(
              child: OutlinedButton(
                onPressed: isLoading ? null : onCancel,
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  side: BorderSide(color: Colors.grey.shade300),
                ),
                child: Text(
                  'Cancel',
                  style: TextStyle(
                    color: Colors.grey.shade700,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: ElevatedButton(
                onPressed: isLoading ? null : onSubmit,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  backgroundColor: theme.primaryColor,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 2,
                ),
                child:
                    isLoading
                        ? const SizedBox(
                          height: 18,
                          width: 18,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation<Color>(
                              Colors.white,
                            ),
                          ),
                        )
                        : Text(
                          editingWork != null ? 'Update' : 'Add Work',
                          style: const TextStyle(fontWeight: FontWeight.w600),
                        ),
              ),
            ),
          ],
        );
      },
    );
  }
}