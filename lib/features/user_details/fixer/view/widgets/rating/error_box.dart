import 'package:flutter/material.dart';
import 'package:quick_pitch_app/core/config/responsive.dart';

/// Error Box Widget
class ErrorBox extends StatelessWidget {
  final Responsive res;
  final ColorScheme colorScheme;
  final String text;

  const ErrorBox({super.key, 
    required this.res,
    required this.colorScheme,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: res.hp(10),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Center(
        child: Text(
          text,
          style: TextStyle(
            fontSize: res.sp(14),
            color: Colors.grey[600],
          ),
        ),
      ),
    );
  }
}
