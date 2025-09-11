// lib/features/settings/view/widgets/settings_widgets.dart

import 'package:flutter/material.dart';

class SettingsItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;
  final bool isHighlighted;
  final bool isDestructive;

  const SettingsItem({
    super.key,
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
    this.isHighlighted = false,
    this.isDestructive = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    Color? iconColor;
    Color? titleColor;

    if (isDestructive) {
      iconColor = theme.colorScheme.error;
      titleColor = theme.colorScheme.error;
    } else if (isHighlighted) {
      iconColor = theme.colorScheme.primary;
      titleColor = theme.colorScheme.primary;
    }

    return ListTile(
      leading: Icon(icon, color: iconColor ?? theme.iconTheme.color, size: 24),
      title: Text(
        title,
        style: TextStyle(
          fontWeight: isHighlighted ? FontWeight.w600 : FontWeight.w500,
          color: titleColor ?? theme.textTheme.titleMedium?.color,
        ),
      ),
      subtitle: Text(
        subtitle,
        style: TextStyle(color: theme.textTheme.bodySmall?.color, fontSize: 12),
      ),
      trailing: Icon(
        Icons.chevron_right,
        color: theme.iconTheme.color?.withValues(alpha: 0.6),
        size: 20,
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      onTap: onTap,
    );
  }
}
