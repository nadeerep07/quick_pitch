import 'package:flutter/material.dart';
import 'package:quick_pitch_app/core/common/main_background_painter.dart';

class BackgroundSection extends StatelessWidget {
  final Animation<double> backgroundAnimation;
  final Widget child;

  const BackgroundSection({
    super.key,
    required this.backgroundAnimation,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: backgroundAnimation,
      builder: (context, _) {
        return Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Colors.white,
                Colors.deepPurple.shade50.withValues(alpha: 0.3),
                Colors.deepPurple.shade100.withValues(alpha: 0.2),
              ],
              stops: const [0.0, 0.6, 1.0],
            ),
          ),
          child: CustomPaint(
            painter: MainBackgroundPainter(),
            child: child,
          ),
        );
      },
    );
  }
}
