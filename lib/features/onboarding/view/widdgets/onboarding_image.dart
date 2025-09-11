import 'package:flutter/material.dart';
import 'package:quick_pitch_app/core/config/responsive.dart';

class OnboardingImage extends StatelessWidget {
  final String imagePath;
  final int index;
  final Responsive res;

  const OnboardingImage({
    super.key,
    required this.imagePath,
    required this.index,
    required this.res,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 400),
      transitionBuilder: (child, animation) => FadeTransition(opacity: animation, child: child),
      child: Image.asset(
        imagePath,
        key: ValueKey('image_$index'),
        height: res.hp(40),
        fit: BoxFit.contain,
      ),
    );
  }
}
