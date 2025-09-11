import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quick_pitch_app/core/config/responsive.dart';
import 'package:quick_pitch_app/features/fixer_work_selection/viewmodel/cubit/fixer_work_selection_cubit.dart';
import 'package:quick_pitch_app/features/fixer_work_upload/model/fixer_work_upload_model.dart';
import 'package:quick_pitch_app/features/profile_completion/model/user_profile_model.dart';

class BottomActionSection extends StatelessWidget {
  final Responsive res;
  final ColorScheme colorScheme;
  final ThemeData theme;
  final FixerWork selectedWork;
  final bool isSubmitting;
  final TextEditingController messageController;
  final UserProfileModel fixerData;

  const BottomActionSection({
    required this.res,
    required this.colorScheme,
    required this.theme,
    required this.selectedWork,
    required this.isSubmitting,
    required this.messageController,
    required this.fixerData,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(res.wp(4)),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        border: Border(top: BorderSide(color: colorScheme.outline.withOpacity(0.2))),
      ),
      child: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              margin: EdgeInsets.only(bottom: res.hp(2)),
              decoration: BoxDecoration(
                color: colorScheme.surfaceContainerHighest.withOpacity(0.5),
                borderRadius: BorderRadius.circular(12),
              ),
              child: TextField(
                controller: messageController,
                maxLines: 3,
                decoration: InputDecoration(
                  hintText: 'Add a message for ${fixerData.name.split(" ").first} (optional)',
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.all(res.wp(3)),
                ),
              ),
            ),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: colorScheme.primary,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  padding: EdgeInsets.symmetric(vertical: res.hp(2)),
                ),
                onPressed: isSubmitting
                    ? null
                    : () {
                        context.read<FixerWorkSelectionCubit>().submitRequest(
                              work: selectedWork,
                              fixer: fixerData,
                              message: messageController.text,
                            );
                      },
                child: isSubmitting
                    ? SizedBox(
                        height: res.sp(20),
                        width: res.sp(20),
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation(colorScheme.onPrimary),
                        ),
                      )
                    : Text(
                        'Send Request for "${selectedWork.title}"',
                        style: TextStyle(
                          fontSize: res.sp(16),
                          fontWeight: FontWeight.w600,
                          color: colorScheme.onPrimary,
                        ),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
