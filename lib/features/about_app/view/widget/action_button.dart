import 'package:flutter/material.dart';
import 'package:quick_pitch_app/core/config/responsive.dart';

class ActionButton extends StatelessWidget {
  final Responsive res;
  final String text;
  final IconData icon;
  final VoidCallback onTap;
  const ActionButton({
    required this.res,
    required this.text,
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: res.hp(2), horizontal: res.wp(4)),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFF667EEA), Color(0xFF764BA2)],
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
          ),
          borderRadius: BorderRadius.circular(res.wp(3)),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF667EEA).withOpacity(0.3),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: Colors.white, size: res.sp(16)),
            SizedBox(width: res.wp(2)),
            Text(
              text,
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w600,
                fontSize: res.sp(14),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
