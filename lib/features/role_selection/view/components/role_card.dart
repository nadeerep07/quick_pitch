import 'package:flutter/material.dart';
import 'package:quick_pitch_app/shared/config/responsive.dart';
import 'package:quick_pitch_app/shared/theme/app_colors.dart';

class RoleBox extends StatelessWidget {
  final String title;
  final String subtitle;
  final String imagePath;
  final VoidCallback onTap;
  final Responsive res;
  final bool isSelected;

  const RoleBox({
    required this.title,
    required this.subtitle,
    required this.imagePath,
    required this.onTap,
    required this.res,
    this.isSelected = false,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          //border: Border.all(color: isSelected ? AppColors.primary : Colors.transparent, ),
          color: Colors.white,
          boxShadow: [
            if (isSelected)
              BoxShadow(
                color: AppColors.primary.withValues(alpha: .4),
                blurRadius: 80,
                offset: Offset(0, 4),
              ),
          ],
        ),
        padding: EdgeInsets.all(res.sp(14)),
        child: Column(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.asset(
                imagePath,
                height: res.hp(20),
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),
            SizedBox(height: res.hp(1.5)),
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                title,
                style: TextStyle(
                  color: Colors.black87,
                  fontSize: res.sp(16),
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            SizedBox(height: res.hp(.9)),
            Align(
              alignment: Alignment.bottomLeft,
              child: Text(
                subtitle,
                style: TextStyle(fontSize: res.sp(15), color: Colors.deepPurple),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
