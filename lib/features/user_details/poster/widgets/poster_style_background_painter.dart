import 'package:flutter/material.dart';

class PosterStyleBackgroundPainter extends CustomPainter {
  final Color baseColor;
  final bool hasImage;
  
  PosterStyleBackgroundPainter({this.baseColor = Colors.blue, this.hasImage = true});
  
  @override
  void paint(Canvas canvas, Size size) {
    final width = size.width;
    final height = size.height;
    
    // Main background with gradient
    final backgroundGradient = LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [
        baseColor.withOpacity(0.9),
        baseColor.withOpacity(0.7),
        baseColor.withOpacity(0.9),
      ],
      stops: [0.0, 0.5, 1.0],
    );
    
    final backgroundPaint = Paint()
      ..shader = backgroundGradient.createShader(Rect.fromLTRB(0, 0, width, height));
    
    canvas.drawRect(Rect.fromLTRB(0, 0, width, height), backgroundPaint);
    
    // Diagonal stripes pattern
    final stripePaint = Paint()
      ..color = baseColor.withOpacity(0.15)
      ..strokeWidth = 1.5;
    
    final stripeCount = 15;
    for (int i = -stripeCount; i < stripeCount; i++) {
      final startX = i * (width / stripeCount);
      canvas.drawLine(
        Offset(startX, 0),
        Offset(startX + height / 0.7, height),
        stripePaint,
      );
    }
    
    // Top left corner accent
    final cornerGradient = RadialGradient(
      center: Alignment.topLeft,
      radius: 0.8,
      colors: [
        Colors.white.withOpacity(0.2),
        Colors.transparent,
      ],
    );
    
    final cornerPaint = Paint()
      ..shader = cornerGradient.createShader(Rect.fromLTRB(0, 0, width * 0.6, height * 0.6));
    
    canvas.drawCircle(Offset(0, 0), width * 0.4, cornerPaint);
    
    // Bottom right corner accent
    final bottomCornerGradient = RadialGradient(
      center: Alignment.bottomRight,
      radius: 0.6,
      colors: [
        Colors.black.withOpacity(0.1),
        Colors.transparent,
      ],
    );
    
    final bottomCornerPaint = Paint()
      ..shader = bottomCornerGradient.createShader(Rect.fromLTRB(width * 0.4, height * 0.4, width, height));
    
    canvas.drawCircle(Offset(width, height), width * 0.5, bottomCornerPaint);
    
    // Decorative border
    final borderPaint = Paint()
      ..color = Colors.white.withOpacity(0.15)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0;
    
    canvas.drawRect(Rect.fromLTRB(2, 2, width - 2, height - 2), borderPaint);
    
    // If no image, add placeholder text
    if (!hasImage) {
      final textPainter = TextPainter(
        text: TextSpan(
          text: 'PORTFOLIO',
          style: TextStyle(
            color: Colors.white.withOpacity(0.7),
            fontSize: 24,
            fontWeight: FontWeight.w900,
            letterSpacing: 4.0,
          ),
        ),
        textDirection: TextDirection.ltr,
      );
      
      textPainter.layout();
      textPainter.paint(
        canvas,
        Offset(
          (width - textPainter.width) / 2,
          (height - textPainter.height) / 2,
        ),
      );
      
      // Subtitle text
      final subtitlePainter = TextPainter(
        text: TextSpan(
          text: 'Quick Pitch',
          style: TextStyle(
            color: Colors.white.withOpacity(0.5),
            fontSize: 12,
            fontWeight: FontWeight.w600,
            letterSpacing: 2.0,
          ),
        ),
        textDirection: TextDirection.ltr,
      );
      
      subtitlePainter.layout();
      subtitlePainter.paint(
        canvas,
        Offset(
          (width - subtitlePainter.width) / 2,
          (height - textPainter.height) / 2 + textPainter.height + 10,
        ),
      );
    }
  }
  
  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}