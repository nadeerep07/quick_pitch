import 'package:flutter/material.dart';

class MainBackgroundPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
   
    final gradientPaint = Paint()
      ..shader = LinearGradient(
        colors: [
          Colors.deepPurple.shade100.withValues(alpha: .3),
          Colors.deepPurple.shade200.withValues(alpha: .2),
        ],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ).createShader(Rect.fromLTWH(0, 0, size.width, size.height));

    final circleCenter = Offset(size.width * 0.2, size.height * 0.2);
    canvas.drawCircle(circleCenter, size.width * 0.6, gradientPaint);

   
    final path = Path()
      ..moveTo(size.width, size.height * 0.6)
      ..quadraticBezierTo(
        size.width * 0.7, size.height * 0.9,
        size.width * 0.3, size.height * 0.8,
      )
      ..quadraticBezierTo(
        0, size.height * 0.7,
        0, size.height,
      )
      ..lineTo(size.width, size.height)
      ..close();

    final curvePaint = Paint()
      ..color = Colors.deepPurple.shade50.withValues(alpha: .4);

    canvas.drawPath(path, curvePaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
