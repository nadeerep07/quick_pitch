import 'package:flutter/material.dart';
import 'package:quick_pitch_app/core/config/responsive.dart';

class PosterHomeQuickActionButton extends StatelessWidget {
  const PosterHomeQuickActionButton({
    super.key,
    required this.icon,
    required this.label,
    required this.res,
  });

  final IconData icon;
  final String label;
  final Responsive res;

  @override
  Widget build(BuildContext context) {
  return Column(
    children: [
      CircleAvatar(
        radius: 24,
        backgroundColor: Colors.blueAccent.withValues(alpha: .1),
        child: Icon(icon, color: Colors.blue, size: res.sp(20)),
      ),
      SizedBox(height: 6),
      Text(label, style: TextStyle(fontSize: res.sp(11))),
    ],
  );
}
}
