import 'package:flutter/material.dart';
import 'package:quick_pitch_app/core/config/responsive.dart';

class ImagePlaceholder extends StatelessWidget {
  final Responsive res;
  final ColorScheme colorScheme;

  const ImagePlaceholder({required this.res, required this.colorScheme});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: res.wp(20),
      height: res.wp(20),
      color: colorScheme.outline.withOpacity(0.1),
      child: Icon(Icons.image_not_supported_outlined,
          color: colorScheme.outline, size: res.sp(24)),
    );
  }
}
