import 'package:flutter/material.dart';
import 'package:quick_pitch_app/core/config/responsive.dart';

class AppLogo extends StatelessWidget {
  final Responsive res;
  const AppLogo({super.key, required this.res});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: res.wp(30),
      height: res.wp(30),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: const LinearGradient(
          colors: [Color(0xFF667EEA), Color(0xFF764BA2)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF667EEA).withValues(alpha:0.3),
            blurRadius: 30,
            spreadRadius: 5,
          ),
        ],
      ),
      child: Icon(
        Icons.flash_on_rounded,
        size: res.wp(15),
        color: Colors.white,
      ),
    );
  }
}
