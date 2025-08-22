import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quick_pitch_app/features/fixer_work_upload/model/fixer_work_upload_model.dart';
import 'package:quick_pitch_app/features/fixer_work_upload/view/components/work_detail_dialog.dart';
import 'package:quick_pitch_app/features/fixer_work_upload/view/widgets/compact_content.dart';
import 'package:quick_pitch_app/features/fixer_work_upload/view/widgets/compact_image.dart';
import 'package:quick_pitch_app/features/fixer_work_upload/viewmodel/bloc/fixer_work_bloc.dart';

class CompactWorkCard extends StatelessWidget {
  final ThemeData theme;
  final FixerWork work;
  final bool isOwner;

  const CompactWorkCard({super.key, 
    required this.theme,
    required this.work,
    required this.isOwner,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: theme.colorScheme.outline.withOpacity(0.1),
        ),
        boxShadow: [
          BoxShadow(
            color: theme.colorScheme.shadow.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => _showWorkDetail(context, work),
          borderRadius: BorderRadius.circular(16),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                CompactImage(theme: theme, work: work),
                const SizedBox(width: 16),
                Expanded(child: CompactContent(theme: theme, work: work)),
                Icon(
                  Icons.arrow_forward_ios_rounded,
                  size: 16,
                  color: theme.colorScheme.onSurface.withOpacity(0.4),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showWorkDetail(BuildContext context, FixerWork work) {
    showDialog(
      context: context,
      builder: (dialogContext) => BlocProvider.value(
        value: BlocProvider.of<FixerWorksBloc>(context),
        child: WorkDetailDialog(
          work: work,
          theme: theme,
          isOwner: isOwner,
        ),
      ),
    );
  }
}
