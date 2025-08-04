import 'package:flutter/material.dart';
import 'package:quick_pitch_app/core/config/responsive.dart';

class TimelineOption extends StatelessWidget {
  final IconData icon;
  final String title;
  final String value;
  final String? groupValue;
  final ValueChanged<String?> onChanged;
  final Responsive res;

  const TimelineOption({super.key, 
    required this.icon,
    required this.title,
    required this.value,
    required this.groupValue,
    required this.onChanged,
    required this.res,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final isSelected = value == groupValue;

    return InkWell(
      onTap: () => onChanged(value),
      borderRadius: BorderRadius.circular(res.wp(2.5)),
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: res.hp(1.5), horizontal: res.wp(4)),
        child: Row(
          children: [
            Icon(
              icon,
              size: res.wp(5),
              color: isSelected ? colorScheme.primary : colorScheme.onSurface.withValues(alpha: 0.6),
            ),
            SizedBox(width: res.wp(3)),
            Text(
              title,
              style: TextStyle(
                fontSize: res.sp(14),
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                color: isSelected ? colorScheme.primary : colorScheme.onSurface,
              ),
            ),
            const Spacer(),
            if (isSelected)
              Icon(
                Icons.check_circle,
                color: colorScheme.primary,
                size: res.wp(5),
              ),
          ],
        ),
      ),
    );
  }
}
