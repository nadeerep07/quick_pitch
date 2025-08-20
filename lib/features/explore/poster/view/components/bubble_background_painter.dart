import 'package:flutter/material.dart';

class BubbleBackgroundPainter extends CustomPainter {
  final Color primaryColor;
  final Color secondaryColor;
  final bool isDarkMode;

  BubbleBackgroundPainter({
    required this.primaryColor,
    required this.secondaryColor,
    required this.isDarkMode,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..style = PaintingStyle.fill;

    // Draw primary color bubbles
    paint.color = primaryColor;
    canvas.drawCircle(Offset(size.width * 0.2, size.height * 0.1), size.width * 0.15, paint);
    canvas.drawCircle(Offset(size.width * 0.8, size.height * 0.3), size.width * 0.1, paint);

    // Draw secondary color bubbles
    paint.color = secondaryColor;
    canvas.drawCircle(Offset(size.width * 0.7, size.height * 0.1), size.width * 0.12, paint);
    canvas.drawCircle(Offset(size.width * 0.3, size.height * 0.4), size.width * 0.08, paint);

    // Draw gradient overlay
    final gradient = LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: [
        (isDarkMode ? Colors.black : Colors.white).withValues(alpha:0.8),
        (isDarkMode ? Colors.black : Colors.white).withValues(alpha:0.9),
      ],
    );
    paint.shader = gradient.createShader(Rect.fromLTRB(0, 0, size.width, size.height));
    canvas.drawRect(Rect.fromLTRB(0, 0, size.width, size.height), paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}