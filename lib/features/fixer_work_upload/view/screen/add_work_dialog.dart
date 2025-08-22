import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:quick_pitch_app/features/fixer_work_upload/model/fixer_work_upload_model.dart';

import 'package:quick_pitch_app/features/fixer_work_upload/view/widgets/add_work/add_work_dialog_content.dart';
import 'package:quick_pitch_app/features/fixer_work_upload/viewmodel/fixer_add_work/cubit/add_work_dialog_cubit.dart';

class AddWorkDialog extends StatelessWidget {
  final String fixerId;
  final ThemeData theme;
  final FixerWork? editingWork;

  const AddWorkDialog({
    super.key,
    required this.fixerId,
    required this.theme,
    this.editingWork,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) {
        final cubit = AddWorkDialogCubit();
        if (editingWork != null) {
          cubit.setExistingImages(List<String>.from(editingWork!.images));
        }
        return cubit;
      },
      child: AddWorkDialogContent(
        fixerId: fixerId,
        theme: theme,
        editingWork: editingWork,
      ),
    );
  }
}
