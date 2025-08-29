import 'package:flutter/material.dart';
import 'package:quick_pitch_app/core/config/app_colors.dart';
import 'package:quick_pitch_app/core/config/responsive.dart';

class Header extends StatelessWidget {
  final Responsive res;
  final ThemeData theme;
  const Header({required this.res, required this.theme});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(Icons.payment, color: AppColors.primary, size: res.wp(6)),
        SizedBox(width: res.wp(3)),
        Expanded(
          child: Text(
            'Request Payment',
            style: theme.textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
          ),
        ),
      ],
    );
  }
}
