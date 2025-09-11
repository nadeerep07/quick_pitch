// lib/features/settings/view/widgets/settings_widgets.dart

import 'package:flutter/material.dart';

class MessageDialog extends StatelessWidget {
  final String title;
  final String message;
  final IconData icon;
  final Color iconColor;
  final String buttonText;
  final VoidCallback? onPressed;

  const MessageDialog({
    super.key,
    required this.title,
    required this.message,
    required this.icon,
    required this.iconColor,
    this.buttonText = 'OK',
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      icon: Icon(icon, color: iconColor, size: 48),
      title: Text(title),
      content: Text(message),
      actions: [
        ElevatedButton(
          onPressed: onPressed ?? () => Navigator.pop(context),
          child: Text(buttonText),
        ),
      ],
    );
  }
}