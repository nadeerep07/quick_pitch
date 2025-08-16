import 'package:flutter/material.dart';

class ChatBackgroundPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    // Main background gradient (lighter at top, slightly darker at bottom)
    final bgGradient = LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: [
        Colors.deepPurple.shade50.withValues(alpha: .2),
        Colors.deepPurple.shade100.withValues(alpha:0.3),
      ],
    );
    
    // Draw the base background
    canvas.drawRect(
      Rect.fromLTRB(0, 0, size.width, size.height),
      Paint()..shader = bgGradient.createShader(
        Rect.fromLTRB(0, 0, size.width, size.height),
      ),
    );

    // Wave parameters
    final waveHeight = size.height * 0.1;
    final waveLength = size.width * 0.5;
    final waveColor = Colors.deepPurple.shade100.withValues(alpha:0.15);

    // Draw multiple subtle waves
    for (int i = 0; i < 3; i++) {
      final wavePath = Path();
      final verticalOffset = size.height * (0.6 + i * 0.1);
      
      wavePath.moveTo(0, verticalOffset);
      
      // Create wave pattern
      for (double x = 0; x < size.width; x += waveLength) {
        wavePath.quadraticBezierTo(
          x + waveLength * 0.25, 
          verticalOffset - waveHeight * (i % 2 == 0 ? 1 : -1),
          x + waveLength * 0.5,
          verticalOffset,
        );
        wavePath.quadraticBezierTo(
          x + waveLength * 0.75, 
          verticalOffset + waveHeight * (i % 2 == 0 ? 1 : -1),
          x + waveLength,
          verticalOffset,
        );
      }
      
      // Fill the area below the wave
      wavePath.lineTo(size.width, size.height);
      wavePath.lineTo(0, size.height);
      wavePath.close();
      
      canvas.drawPath(
        wavePath,
        Paint()
          ..color = waveColor.withValues(alpha:0.1 * (3 - i))
          ..blendMode = BlendMode.multiply,
      );
    }

    // Add subtle grid lines (like notebook paper but very faint)
    final gridPaint = Paint()
      ..color = Colors.deepPurple.shade100.withValues(alpha:0.05)
      ..strokeWidth = 0.5;

    // Vertical lines
    for (double x = 0; x < size.width; x += 40) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), gridPaint);
    }

    // Horizontal lines (more spaced out)
    for (double y = 0; y < size.height; y += 60) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), gridPaint);
    }

    // Add some very subtle circular highlights
    final highlightPaint = Paint()
      ..color = Colors.white.withValues(alpha:0.03)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 20);

    canvas.drawCircle(
      Offset(size.width * 0.3, size.height * 0.2),
      size.width * 0.2,
      highlightPaint,
    );
    canvas.drawCircle(
      Offset(size.width * 0.7, size.height * 0.3),
      size.width * 0.15,
      highlightPaint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}