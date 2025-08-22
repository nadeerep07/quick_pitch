import 'package:flutter/material.dart';
import 'package:quick_pitch_app/core/common/app_button.dart';
import 'package:quick_pitch_app/core/config/app_colors.dart';
import 'package:quick_pitch_app/core/config/responsive.dart';
import 'package:quick_pitch_app/features/profile_completion/model/user_profile_model.dart';
import 'package:quick_pitch_app/features/user_details/fixer/view/screen/fixer_detail_screen.dart';

class ActionButtons extends StatelessWidget {
  final Responsive res;
  final UserProfileModel fixerData;

  const ActionButtons({super.key, required this.res, required this.fixerData});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: AppButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => FixerDetailScreen(fixerData: fixerData),
                ),
              );
            },
            text: 'View Profile',
          ),
        ),
      ],
    );
  }
}
