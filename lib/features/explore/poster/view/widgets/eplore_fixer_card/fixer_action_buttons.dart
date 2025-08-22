import 'package:flutter/material.dart';
import 'package:quick_pitch_app/core/config/responsive.dart';
import 'package:quick_pitch_app/features/profile_completion/model/user_profile_model.dart';
import 'package:quick_pitch_app/features/user_details/fixer/view/screen/fixer_detail_screen.dart';

class FixerActionButtons extends StatelessWidget {
  final UserProfileModel fixer;
  final Responsive res;
  final ThemeData theme;

  const FixerActionButtons({
    super.key,
    required this.fixer,
    required this.res,
    required this.theme,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          width: res.wp(20),
          child: ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => FixerDetailScreen(fixerData: fixer),
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: theme.primaryColor,
              foregroundColor: Colors.white,
              padding: EdgeInsets.symmetric(vertical: res.hp(1)),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: Text(
              'View',
              style: TextStyle(fontSize: res.sp(12)),
            ),
          ),
        ),
      ],
    );
  }
}
