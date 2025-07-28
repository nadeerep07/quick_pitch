import 'package:flutter/material.dart';
import 'package:quick_pitch_app/core/config/responsive.dart';

class PaymentTypeCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final bool isSelected;
  final VoidCallback onTap;
  final Responsive res;

  const PaymentTypeCard({
    required this.icon,
    required this.title,
    required this.isSelected,
    required this.onTap,
    required this.res,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(res.wp(3)),
      child: Container(
        padding: EdgeInsets.symmetric(vertical: res.hp(2), horizontal: res.wp(2)),
        decoration: BoxDecoration(
          color: isSelected ? colorScheme.primary.withOpacity(0.1) : Colors.transparent,
          borderRadius: BorderRadius.circular(res.wp(3)),
          border: Border.all(
            color: isSelected ? colorScheme.primary : Colors.transparent,
            width: 1.5,
          ),
        ),
        child: Column(
          children: [
            Icon(
              icon,
              size: res.wp(7),
              color: isSelected ? colorScheme.primary : colorScheme.onSurface.withOpacity(0.6),
            ),
            SizedBox(height: res.hp(1)),
            Text(
              title,
              style: TextStyle(
                fontSize: res.sp(14),
                fontWeight: FontWeight.bold,
                color: isSelected ? colorScheme.primary : colorScheme.onSurface,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
