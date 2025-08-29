import 'package:flutter/material.dart';
import 'package:quick_pitch_app/core/config/responsive.dart';

/// --------------------------
/// Avatar
/// --------------------------
class PosterAvatar extends StatelessWidget {
  final String? imageUrl;
  final ColorScheme colorScheme;
  final Responsive res;

  const PosterAvatar({
    required this.imageUrl,
    required this.colorScheme,
    required this.res,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: res.sp(50),
      height: res.sp(50),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
          color: colorScheme.primary.withValues(alpha: 0.2),
          width: 2,
        ),
      ),
      child: ClipOval(
        child: imageUrl != null
            ? Image.network(
                imageUrl!,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => Icon(
                  Icons.person,
                  size: res.sp(24),
                  color: colorScheme.primary,
                ),
              )
            : Icon(
                Icons.person,
                size: res.sp(24),
                color: colorScheme.primary,
              ),
      ),
    );
  }
}

