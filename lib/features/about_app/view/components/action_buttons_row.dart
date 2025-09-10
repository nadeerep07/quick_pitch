import 'package:flutter/material.dart';
import 'package:quick_pitch_app/core/config/responsive.dart';
import 'package:quick_pitch_app/features/about_app/view/screen/privacy_policy_screen.dart';
import 'package:quick_pitch_app/features/about_app/view/widget/action_button.dart';

class ActionButtonsRow extends StatelessWidget {
  final Responsive res;
  const ActionButtonsRow({super.key, required this.res});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: ActionButton(
            res: res,
            text: 'Privacy Policy',
            icon: Icons.privacy_tip_outlined,
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => const PrivacyPolicyScreen()));
            },
          ),
        ),
        SizedBox(width: res.wp(4)),
        Expanded(
          child: ActionButton(
            res: res,
            text: 'Rate Us',
            icon: Icons.star_outline_rounded,
            onTap: () {},
          ),
        ),
      ],
    );
  }
}
