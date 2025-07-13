import 'package:flutter/material.dart';

class BuildChip extends StatelessWidget {
  const BuildChip({
    super.key,
    required this.label,
    required this.color,
  });

  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) => Chip(
        label: Text(label),
        backgroundColor: color.withValues(alpha: .2),
        labelStyle: TextStyle(color: color, fontWeight: FontWeight.w500),
      );
}
