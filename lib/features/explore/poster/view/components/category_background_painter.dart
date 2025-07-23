import 'package:flutter/material.dart';

class CategoryBackgroundPainter extends CustomPainter {
  final Color baseColor;
  final Color highlightColor;

  CategoryBackgroundPainter({
    required this.baseColor,
    required this.highlightColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..style = PaintingStyle.fill
      ..isAntiAlias = true;

    // Draw base rounded rectangle
    final baseRect = RRect.fromRectAndRadius(
      Rect.fromLTWH(0, 0, size.width, size.height),
      Radius.circular(12),
    );
    
    // Base background
    paint.color = baseColor;
    canvas.drawRRect(baseRect, paint);

    // Subtle highlight effect
    final highlightPath = Path()
      ..moveTo(0, size.height * 0.7)
      ..quadraticBezierTo(
        size.width * 0.3,
        size.height * 0.6,
        size.width * 0.7,
        size.height * 0.8,
      )
      ..quadraticBezierTo(
        size.width * 0.9,
        size.height * 0.9,
        size.width,
        size.height * 0.7,
      )
      ..lineTo(size.width, size.height)
      ..lineTo(0, size.height)
      ..close();

    paint.color = highlightColor;
    canvas.drawPath(highlightPath, paint);

    // Border
    paint
      ..style = PaintingStyle.stroke
      ..color = Colors.white.withValues(alpha: .3)
      ..strokeWidth = 1.0;
    canvas.drawRRect(baseRect, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}