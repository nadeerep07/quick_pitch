import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'dart:typed_data';
import 'package:quick_pitch_app/features/profile_completion/model/user_profile_model.dart';

class CustomMarkerPainter extends CustomPainter {
  final UserProfileModel fixer;
  final Color certificateColor;
  final bool isSelected;

  CustomMarkerPainter({
    required this.fixer,
    required this.certificateColor,
    this.isSelected = false,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = isSelected ? Colors.blue : certificateColor
      ..style = PaintingStyle.fill;

    final borderPaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3;

    // Draw circle background
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2 - 3;
    
    canvas.drawCircle(center, radius, paint);
    canvas.drawCircle(center, radius, borderPaint);

    // Draw initials
    final textPainter = TextPainter(
      text: TextSpan(
        text: _getInitials(fixer.name),
        style: TextStyle(
          color: Colors.white,
          fontSize: size.width * 0.35,
          fontWeight: FontWeight.bold,
        ),
      ),
      textDirection: TextDirection.ltr,
    );
    
    textPainter.layout();
    final textOffset = Offset(
      center.dx - textPainter.width / 2,
      center.dy - textPainter.height / 2,
    );
    
    textPainter.paint(canvas, textOffset);
  }

  String _getInitials(String name) {
    final names = name.trim().split(' ');
    if (names.length >= 2) {
      return '${names[0][0]}${names[1][0]}'.toUpperCase();
    } else if (names.isNotEmpty) {
      return names[0].substring(0, names[0].length >= 2 ? 2 : 1).toUpperCase();
    }
    return 'F';
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}

class MarkerGenerator {
  static Future<BitmapDescriptor> createCustomMarker({
    required UserProfileModel fixer,
    required Color certificateColor,
    bool isSelected = false,
  }) async {
    const size = 120.0;
    final recorder = ui.PictureRecorder();
    final canvas = Canvas(recorder);
    
    final painter = CustomMarkerPainter(
      fixer: fixer,
      certificateColor: certificateColor,
      isSelected: isSelected,
    );
    
    painter.paint(canvas, const Size(size, size));
    
    final picture = recorder.endRecording();
    final img = await picture.toImage(size.toInt(), size.toInt());
    final byteData = await img.toByteData(format: ui.ImageByteFormat.png);
    final uint8List = byteData!.buffer.asUint8List();
    
    return BitmapDescriptor.fromBytes(uint8List);
  }

  static Color getCertificateStatusColor(String? status) {
    switch (status?.toLowerCase()) {
      case 'verified':
        return Colors.green;
      case 'pending':
        return Colors.orange;
      case 'rejected':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }
}