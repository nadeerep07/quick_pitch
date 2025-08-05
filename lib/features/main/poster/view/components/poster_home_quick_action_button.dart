import 'package:flutter/material.dart';
import 'package:quick_pitch_app/core/config/responsive.dart';

class PosterHomeQuickActionButton extends StatelessWidget {
  const PosterHomeQuickActionButton({
    super.key,
    required this.res,
    required this.title,
    required this.icon,
    required this.color,
    required this.onTap,
  });

  final Responsive res;
  final String title;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: res.hp(2)),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.9),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: const Color(0xFFE2E8F0)),
          boxShadow: const [
            BoxShadow(
              color: Color(0x08000000),
              blurRadius: 4,
              offset: Offset(0, 1),
            ),
          ],
        ),
        child: Column(
          children: [
            Icon(icon, color: color, size: 28),
            SizedBox(height: res.hp(0.5)),
            Text(
              title,
              style: TextStyle(
                fontSize: res.sp(12),
                fontWeight: FontWeight.w600,
                color: const Color(0xFF475569),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
