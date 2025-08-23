import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quick_pitch_app/features/fixer_work_upload/model/fixer_work_upload_model.dart';
import 'package:quick_pitch_app/features/fixer_work_upload/viewmodel/fixer_work/bloc/fixer_work_bloc.dart';
import 'package:quick_pitch_app/features/fixer_work_upload/viewmodel/fixer_work/bloc/fixer_work_event.dart';

class WorkDetailDeleteConfirmationDialog extends StatelessWidget {
  final FixerWork work;
  final ThemeData theme;

  const WorkDetailDeleteConfirmationDialog({super.key, required this.work, required this.theme});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text("Delete Work"),
      content: const Text("Are you sure you want to delete this work?"),
      actions: [
        TextButton(onPressed: () => Navigator.pop(context), child: const Text("Cancel")),
        FilledButton(
          onPressed: () {
            Navigator.pop(context);
            Navigator.pop(context);
            context.read<FixerWorksBloc>().add(DeleteFixerWork(work));
          },
          style: FilledButton.styleFrom(backgroundColor: theme.colorScheme.error),
          child: const Text("Delete"),
        ),
      ],
    );
  }
}
