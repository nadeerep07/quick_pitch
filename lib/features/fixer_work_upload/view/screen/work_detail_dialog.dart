

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quick_pitch_app/features/fixer_work_upload/model/fixer_work_upload_model.dart';
import 'package:quick_pitch_app/features/fixer_work_upload/view/widgets/work_detail/dialog_content.dart';
import 'package:quick_pitch_app/features/fixer_work_upload/viewmodel/work_detail/cubit/work_detail_cubit.dart';

class WorkDetailDialog extends StatelessWidget {
  final FixerWork work;
  final ThemeData theme;
  final bool isOwner;

  const WorkDetailDialog({
    super.key,
    required this.work,
    required this.theme,
    this.isOwner = false,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => WorkDetailCubit(),
      child: Dialog(
        backgroundColor: Colors.transparent,
        elevation: 0,
        insetPadding: const EdgeInsets.all(16),
        child: DialogContent(
          work: work,
          theme: theme,
          isOwner: isOwner,
        ),
      ),
    );
  }
}
