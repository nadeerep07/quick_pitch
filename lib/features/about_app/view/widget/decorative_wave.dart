import 'package:flutter/material.dart';
import 'package:quick_pitch_app/core/config/responsive.dart';

class DecorativeWave extends StatelessWidget {
  final Responsive res;
  const DecorativeWave({super.key, required this.res});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: res.hp(8),
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            const Color(0xFF667EEA).withOpacity(0.1),
            const Color(0xFF764BA2).withOpacity(0.1),
          ],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
        borderRadius: BorderRadius.circular(res.wp(8)),
      ),
    );
  }
}
