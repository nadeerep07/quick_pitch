import 'package:flutter/material.dart';
import 'package:quick_pitch_app/core/config/responsive.dart';

class OnboardingTexts extends StatelessWidget {
  final String title;
  final String subtitle;
  final int index;
  final Responsive res;

  const OnboardingTexts({
    super.key,
    required this.title,
    required this.subtitle,
    required this.index,
    required this.res,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Title
        AnimatedSwitcher(
          duration: const Duration(milliseconds: 500),
          transitionBuilder: (child, animation) {
            return SlideTransition(
              position: Tween<Offset>(
                begin: const Offset(1.0, 0.0),
                end: Offset.zero,
              ).animate(CurvedAnimation(parent: animation, curve: Curves.easeOutCubic)),
              child: FadeTransition(opacity: animation, child: child),
            );
          },
          child: Text(
            title,
            key: ValueKey('title_$index'),
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: res.sp(24), fontWeight: FontWeight.bold, color: Colors.black),
          ),
        ),
        SizedBox(height: res.hp(2)),
        // Subtitle
        AnimatedSwitcher(
          duration: const Duration(milliseconds: 600),
          transitionBuilder: (child, animation) {
            return SlideTransition(
              position: Tween<Offset>(begin: const Offset(1.2, 0.0), end: Offset.zero)
                  .animate(CurvedAnimation(parent: animation, curve: Curves.easeOutCubic)),
              child: FadeTransition(opacity: animation, child: child),
            );
          },
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: res.wp(8)),
            child: Text(
              subtitle,
              key: ValueKey('subtitle_$index'),
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: res.sp(16), color: Colors.grey[600], height: 1.4),
            ),
          ),
        ),
      ],
    );
  }
}
