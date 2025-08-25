import 'package:flutter/material.dart';
import 'package:quick_pitch_app/core/common/app_button.dart';

class FixerActionButtons extends StatelessWidget {
  final VoidCallback onViewProfile;

  const FixerActionButtons({
    super.key,
    required this.onViewProfile,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: AppButton(
            text: 'View Profile',
            onPressed: onViewProfile,
            height: 50,
          ),
        ),
      ],
    );
  }
}
