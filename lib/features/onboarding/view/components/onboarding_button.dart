import 'package:flutter/material.dart';

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
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: Theme.of(context).colorScheme.primary,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
          minimumSize: const Size.fromHeight(50),
        ),
        child: Text(isLast ? 'Get Started' : 'Next'),
      ),
    );
  }
}
