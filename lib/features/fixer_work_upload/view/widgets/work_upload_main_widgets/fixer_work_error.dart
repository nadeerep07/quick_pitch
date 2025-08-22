import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quick_pitch_app/features/fixer_work_upload/view/screen/work_upload_screen.dart';
import 'package:quick_pitch_app/features/fixer_work_upload/viewmodel/fixer_work/bloc/fixer_work_bloc.dart';
import 'package:quick_pitch_app/features/fixer_work_upload/viewmodel/fixer_work/bloc/fixer_work_event.dart';

class FixerWorkError extends StatelessWidget {
  const FixerWorkError({
    super.key,
    required this.widget,
    required this.context,
    required this.message,
  });

  final FixerWorksSection widget;
  final BuildContext context;
  final String message;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(32),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.red.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(Icons.error_outline, size: 32, color: Colors.red[400]),
          ),
          const SizedBox(height: 16),
          Text(
            'Unable to load projects',
            style: widget.theme.textTheme.titleMedium?.copyWith(
              color: widget.theme.colorScheme.onSurface,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            message,
            style: widget.theme.textTheme.bodySmall?.copyWith(
              color: widget.theme.colorScheme.onSurface.withOpacity(0.6),
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          TextButton.icon(
            onPressed: () {
              context.read<FixerWorksBloc>().add(
                LoadFixerWorks(widget.fixerId),
              );
            },
            icon: const Icon(Icons.refresh_rounded),
            label: const Text('Try Again'),
          ),
        ],
      ),
    );
  }
}
