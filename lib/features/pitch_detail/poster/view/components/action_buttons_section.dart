import 'package:flutter/material.dart';
import 'package:quick_pitch_app/core/common/app_button.dart';
import 'package:quick_pitch_app/core/common/show_lottie_cofirmation.dart';
import 'package:quick_pitch_app/core/config/app_colors.dart';
import 'package:quick_pitch_app/core/config/responsive.dart';
import 'package:quick_pitch_app/features/pitch_detail/poster/repository/pitch_detail_repository.dart';
import 'package:quick_pitch_app/features/pitch_detail/poster/view/components/rejection_dialog.dart';
import 'package:quick_pitch_app/features/poster_task/model/task_post_model.dart';
import 'package:quick_pitch_app/features/task_pitching/model/pitch_model.dart';

/// Action Buttons Section
class ActionButtonsSection extends StatelessWidget {
  final TaskPostModel task;
  final PitchModel pitch;
  const ActionButtonsSection({
    super.key,
    required this.task,
    required this.pitch,
  });

  @override
  Widget build(BuildContext context) {
    final res = Responsive(context);
    final repo = PitchDetailRepository();

    return Row(
      children: [
        Expanded(
          child: AppButton(
            text: 'Accept Pitch',
            onPressed: () async {
              try {
                await repo.acceptPitch(pitch, task);
                await showLottieConfirmation(
                  context,
                  animationPath:
                      'assets/animations/Loading 40 _ Paperplane.json',
                  closeAfter: Duration(seconds: 1),
                );
                Navigator.pop(context);
              } catch (e) {
                //  print(e);
                await showLottieConfirmation(
                  context,
                  message: "Already Assigned ",
                  animationPath: 'assets/animations/No file found.json',
                  closeAfter: Duration(seconds: 1),
                );
                Navigator.pop(context);
              }
            },
          ),
        ),
        SizedBox(width: res.wp(4)),
        Expanded(
          child: OutlinedButton(
            onPressed: () async {
              final rejectionMessage = await showRejectionDialog(context);

              if (rejectionMessage != null) {
                await repo.rejectPitch(
                  pitch,
                  rejectionMessage,
                ); // later you can pass rejectionMessage too
                await showLottieConfirmation(
                  context,

                  animationPath:
                      'assets/animations/Loading 40 _ Paperplane.json',
                  closeAfter: const Duration(seconds: 2),
                );
               Navigator.pop(context);
              }
            },
            style: OutlinedButton.styleFrom(
              padding: EdgeInsets.symmetric(vertical: res.hp(2)),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(res.wp(3)),
              ),
              side: BorderSide(color: AppColors.primaryColor),
            ),
            child: Text(
              'Reject',
              style: TextStyle(
                fontSize: res.sp(16),
                fontWeight: FontWeight.bold,
                color: AppColors.primaryColor,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
