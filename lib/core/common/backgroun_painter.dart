import 'package:flutter/material.dart';

class BackgroundPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          Colors.deepPurple.shade100.withValues(alpha: .3),
          Colors.deepPurple.shade200.withValues(alpha: .2),
        ],
      ).createShader(
        Rect.fromCircle(
          center: Offset(size.width / 2, size.height / 2),
          radius: size.width,
        ),
      );

    final center = Offset(size.width / 2, size.height / 2);
    canvas.drawCircle(center, size.width * 0.7, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
