import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quick_pitch_app/features/fixer_work_upload/model/fixer_work_upload_model.dart';
import 'package:quick_pitch_app/features/fixer_work_upload/view/screen/add_work_dialog.dart';
import 'package:quick_pitch_app/features/fixer_work_upload/view/widgets/work_detail/work_detail_delete_confirmation_dialog.dart';
import 'package:quick_pitch_app/features/fixer_work_upload/viewmodel/fixer_work/bloc/fixer_work_bloc.dart';

class WorkDetailActionBar extends StatelessWidget {
  final FixerWork work;
  final ThemeData theme;

  const WorkDetailActionBar({
    super.key,
    required this.work,
    required this.theme,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(color: theme.colorScheme.outline.withOpacity(0.1)),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          OutlinedButton.icon(
            onPressed: () => _showDeleteDialog(context),
            icon: Icon(Icons.delete_outline, color: theme.colorScheme.error),
            label: const Text("Delete"),
          ),
          const SizedBox(width: 12),
          FilledButton.icon(
            onPressed: () => _editWork(context),
            icon: const Icon(Icons.edit),
            label: const Text("Edit"),
          ),
        ],
      ),
    );
  }

  void _editWork(BuildContext context) {
    Navigator.of(context).pop();
    showDialog(
      context: context,
      builder:
          (ctx) => BlocProvider.value(
            value: context.read<FixerWorksBloc>(),
            child: AddWorkDialog(
              fixerId: work.fixerId,
              theme: theme,
              editingWork: work,
            ),
          ),
    );
  }

void _showDeleteDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (_) => BlocProvider.value(
      value: context.read<FixerWorksBloc>(),
      child: WorkDetailDeleteConfirmationDialog(
        work: work,
        theme: theme,
      ),
    ),
  );
}

}
