import 'package:flutter/material.dart';
import 'package:quick_pitch_app/core/config/responsive.dart';

class DetailRow extends StatelessWidget {
  final String label;
  final String value;
  final Responsive res;
  final ThemeData theme;

  const DetailRow({
    required this.label,
    required this.value,
    required this.res,
    required this.theme,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: theme.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w500),
        ),
        Expanded(
          child: Text(
            value,
            style: theme.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.bold),
            textAlign: TextAlign.end,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}