import 'package:flutter/material.dart';

class SkillChip extends StatelessWidget {
  final String label;
  final ThemeData theme;
  final bool isExtra;

  const SkillChip({super.key, required this.label, required this.theme, this.isExtra = false});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(right: 8),
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: isExtra ? Colors.grey.shade100 : Colors.blue.shade50,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: isExtra ? Colors.grey.shade200 : Colors.blue.shade100,
          width: 0.5,
        ),
      ),
      child: Text(
        label,
        style: theme.textTheme.bodySmall?.copyWith(
          color: isExtra ? Colors.grey.shade700 : Colors.blue.shade800,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}
