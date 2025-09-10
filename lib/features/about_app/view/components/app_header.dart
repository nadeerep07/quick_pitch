import 'package:flutter/material.dart';
import 'package:quick_pitch_app/core/config/responsive.dart';

class AppHeader extends StatelessWidget {
  final Responsive res;
  const AppHeader({super.key, required this.res});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          'QuickPitch',
          style: TextStyle(
            fontSize: res.sp(28),
            fontWeight: FontWeight.bold,
            color: const Color(0xFF1F2937),
            letterSpacing: -0.5,
          ),
        ),
        SizedBox(height: res.hp(1)),
        Text(
          'Connect. Pitch. Get Work Done.',
          style: TextStyle(
            fontSize: res.sp(14),
            fontWeight: FontWeight.w500,
            color: const Color(0xFF667EEA),
            letterSpacing: 0.2,
          ),
        ),
      ],
    );
  }
}
