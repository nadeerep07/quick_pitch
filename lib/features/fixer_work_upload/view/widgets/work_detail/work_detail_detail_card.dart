import 'package:flutter/material.dart';

class WorkDetailDetailCard extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  final ThemeData theme;

  const WorkDetailDetailCard({
    required this.label,
    required this.value,
    required this.icon,
    required this.theme,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceVariant.withOpacity(0.3),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(children: [Icon(icon, size: 16, color: theme.colorScheme.primary), const SizedBox(width: 8), Text(label)]),
          const SizedBox(height: 8),
          Text(value, style: theme.textTheme.bodyMedium),
        ],
      ),
    );
  }
}