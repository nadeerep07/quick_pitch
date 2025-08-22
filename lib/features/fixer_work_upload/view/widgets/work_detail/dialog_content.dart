import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:quick_pitch_app/features/fixer_work_upload/model/fixer_work_upload_model.dart';
import 'package:quick_pitch_app/features/fixer_work_upload/view/screen/add_work_dialog.dart';
import 'package:quick_pitch_app/features/fixer_work_upload/view/widgets/work_detail/modern_action_bar.dart';
import 'package:quick_pitch_app/features/fixer_work_upload/view/widgets/work_detail/work_detail_content.dart';
import 'package:quick_pitch_app/features/fixer_work_upload/view/widgets/work_detail/work_detail_header.dart';
import 'package:quick_pitch_app/features/fixer_work_upload/viewmodel/fixer_work/bloc/fixer_work_bloc.dart';
import 'package:quick_pitch_app/features/fixer_work_upload/viewmodel/fixer_work/bloc/fixer_work_event.dart';
import 'package:quick_pitch_app/features/fixer_work_upload/viewmodel/work_detail/cubit/work_detail_cubit.dart';

class DialogContent extends StatelessWidget {
  final FixerWork work;
  final ThemeData theme;
  final bool isOwner;

  const DialogContent({
    super.key,
    required this.work,
    required this.theme,
    required this.isOwner,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<WorkDetailCubit, WorkDetailState>(
      builder: (context, state) {
        return TweenAnimationBuilder<double>(
          duration: const Duration(milliseconds: 300),
          tween: Tween<double>(begin: 0.0, end: 1.0),
          curve: Curves.easeOutBack,
          builder: (context, value, child) {
            return Transform.scale(
              scale: 0.7 + (0.3 * value),
              child: Opacity(
                opacity: value.clamp(0.0, 1.0),
                child: Container(
                  constraints: const BoxConstraints(
                    maxWidth: 600,
                    maxHeight: 700,
                  ),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(24),
                    color: theme.colorScheme.surface,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.15),
                        blurRadius: 30,
                        offset: const Offset(0, 15),
                        spreadRadius: -5,
                      ),
                    ],
                  ),
                  clipBehavior: Clip.antiAlias,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      WorkDetailHeader(work: work, theme: theme),
                      Expanded(
                        child: WorkDetailContent(work: work, theme: theme),
                      ),
                      if (isOwner) WorkDetailActionBar(work: work, theme: theme),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }
}
