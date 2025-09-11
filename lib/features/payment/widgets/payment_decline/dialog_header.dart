import 'package:flutter/material.dart';
import 'package:quick_pitch_app/core/config/responsive.dart';

class DialogHeader extends StatelessWidget {
  final Responsive res;
  final ThemeData theme;

  const DialogHeader({required this.res, required this.theme});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(Icons.cancel, color: Colors.red[500], size: res.wp(6)),
        SizedBox(width: res.wp(3)),
        Expanded(
          child: Text(
            'Decline Payment Request',
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }
}
