import 'package:flutter/material.dart';
import 'package:quick_pitch_app/core/common/app_button.dart';

class OnboardingNextButton extends StatelessWidget {
  final bool isLast;
  final VoidCallback onPressed;

  const OnboardingNextButton({
    super.key,
    required this.isLast,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child:  AppButton(
        text: isLast ? 'Get Started' : 'Next',
        onPressed: onPressed,
      ),
       
    );
  }
}
