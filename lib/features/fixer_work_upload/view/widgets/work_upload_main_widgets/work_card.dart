import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quick_pitch_app/features/fixer_work_upload/model/fixer_work_upload_model.dart';
import 'package:quick_pitch_app/features/fixer_work_upload/view/widgets/work_detail/image_full_screen_dialog.dart';
import 'package:quick_pitch_app/features/fixer_work_upload/view/screen/work_detail_dialog.dart';
import 'package:quick_pitch_app/features/fixer_work_upload/view/widgets/work_upload_main_widgets/card_content.dart';
import 'package:quick_pitch_app/features/fixer_work_upload/view/widgets/work_upload_main_widgets/image_section.dart';
import 'package:quick_pitch_app/features/fixer_work_upload/viewmodel/fixer_work/bloc/fixer_work_bloc.dart';

class WorkCard extends StatelessWidget {
  final ThemeData theme;
  final FixerWork work;
  final bool isOwner;

  const WorkCard({super.key, 
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
        border: Border.all(color: theme.colorScheme.outline.withOpacity(0.1)),
        boxShadow: [
          BoxShadow(
            color: theme.colorScheme.shadow.withOpacity(0.08),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => _showWorkDetail(context, work),
          borderRadius: BorderRadius.circular(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(flex: 2, child: ImageSection(theme: theme, work: work)),
              CardContent(theme: theme, work: work),
            ],
          ),
        ),
      ),
    );
  }

  void _showWorkDetail(BuildContext context, FixerWork work) {
    showDialog(
      context: context,
      builder:
          (dialogContext) => BlocProvider.value(
            value: BlocProvider.of<FixerWorksBloc>(context),
            child: WorkDetailDialog(work: work, theme: theme, isOwner: isOwner),
          ),
    );
  }
}
