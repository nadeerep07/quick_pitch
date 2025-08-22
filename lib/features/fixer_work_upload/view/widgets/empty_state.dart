import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quick_pitch_app/features/fixer_work_upload/view/screen/add_work_dialog.dart';
import 'package:quick_pitch_app/features/fixer_work_upload/viewmodel/bloc/fixer_work_bloc.dart';

class EmptyState extends StatelessWidget {
  final ThemeData theme;
  final bool isOwner;

  const EmptyState({super.key, 
    required this.theme,
    required this.isOwner,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(40),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: theme.colorScheme.surfaceVariant.withOpacity(0.5),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.work_outline,
              size: 40,
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 20),
          Text(
            isOwner ? 'No projects yet' : 'No projects to display',
            style: theme.textTheme.titleMedium?.copyWith(
              color: theme.colorScheme.onSurface,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            isOwner
                ? 'Start building your portfolio by adding your first project'
                : 'This fixer hasn\'t added any projects yet',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurface.withOpacity(0.6),
            ),
            textAlign: TextAlign.center,
          ),
          if (isOwner) ...[
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: () => showDialog(
                context: context,
                builder: (dialogContext) => BlocProvider.value(
                  value: BlocProvider.of<FixerWorksBloc>(context),
                  child: AddWorkDialog(fixerId: '', theme: theme),
                ),
              ),
              icon: const Icon(Icons.add_rounded),
              label: const Text('Add Your First Project'),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 12,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}