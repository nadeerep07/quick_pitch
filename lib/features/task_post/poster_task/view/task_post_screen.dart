import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quick_pitch_app/core/common/app_button.dart';
import 'package:quick_pitch_app/core/common/discard_changes_dialog.dart';
import 'package:quick_pitch_app/core/common/main_background_painter.dart';
import 'package:quick_pitch_app/features/task_post/poster_task/view/components/priority_selector.dart';
import 'package:quick_pitch_app/features/task_post/poster_task/view/components/task_category_selector.dart';
import 'package:quick_pitch_app/features/task_post/poster_task/view/components/task_deadline_picker.dart';
import 'package:quick_pitch_app/features/task_post/poster_task/view/components/task_image_uploader.dart';
import 'package:quick_pitch_app/features/task_post/poster_task/view/components/task_input_fileds.dart';
import 'package:quick_pitch_app/features/task_post/poster_task/view/components/task_location_selector.dart';
import 'package:quick_pitch_app/features/task_post/poster_task/view/components/time_slot_selector.dart';
import 'package:quick_pitch_app/features/task_post/poster_task/view/components/work_type_selector.dart';
import 'package:quick_pitch_app/features/task_post/poster_task/viewmodel/cubit/task_post_cubit.dart';

class TaskPostScreen extends StatelessWidget {
  const TaskPostScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<TaskPostCubit>();
    Future<bool> _handleBackPressed(
      BuildContext context,
      TaskPostCubit cubit,
    ) async {
      final hasChanges = cubit.hasFormChanged();
      if (!hasChanges) return true;

      final result = await showDialog<bool>(
        context: context,
        builder: (_) => const DiscardChangesDialog(),
      );

      return result ?? false;
    }

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) async {
        if (didPop) return;

        final shouldPop = await _handleBackPressed(context, cubit);
        if (shouldPop) {
          Navigator.of(context).pop();
        }
      },

      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            "New Task",
            style: TextStyle(fontWeight: FontWeight.w600),
          ),
          backgroundColor: Colors.transparent,
          elevation: 0,
        ),
        body: BlocBuilder<TaskPostCubit, TaskPostState>(
          builder: (context, state) {
            return CustomPaint(
              painter: MainBackgroundPainter(),
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
                child: Form(
                  key: cubit.formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TaskInputFields(cubit: cubit),
                      const SizedBox(height: 16),
                      TaskDeadlinePicker(cubit: cubit),
                      const SizedBox(height: 16),
                      TaskCategorySelector(cubit: cubit),
                      const SizedBox(height: 16),
                      TaskPrioritySelector(cubit: cubit),
                      const SizedBox(height: 16),
                      TaskWorkTypeSelector(cubit: cubit),
                      const SizedBox(height: 16),
                      TaskLocationSelector(cubit: cubit),
                      const SizedBox(height: 16),
                      if (cubit.selectedWorkType == "On-site")
                        TaskTimeSlotSelector(cubit: cubit),
                      const SizedBox(height: 16),
                      TaskImageUploader(cubit: cubit),
                      const SizedBox(height: 16),
                      SizedBox(
                        width: double.infinity,
                        child: AppButton(
                          text: "Post Task",
                          onPressed: () => cubit.submitTask(context),
                          isLoading: state is TaskPostLoading,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
