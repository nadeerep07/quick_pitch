import 'package:flutter/material.dart';
import 'package:quick_pitch_app/core/config/responsive.dart';

class AppDescriptionCard extends StatelessWidget {
  final Responsive res;
  const AppDescriptionCard({super.key, required this.res});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(res.wp(4)),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(res.wp(4)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Text(
        'QuickPitch helps posters post tasks, and skilled fixers can pitch their services, complete work, and earn securely.',
        style: TextStyle(
          fontSize: res.sp(14),
          height: 1.6,
          color: const Color(0xFF6B7280),
          fontWeight: FontWeight.w400,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }
}
