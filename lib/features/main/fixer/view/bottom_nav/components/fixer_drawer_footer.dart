// Section-wise refactored FixerCustomDrawer

import 'package:flutter/material.dart';

class FixerDrawerFooter extends StatelessWidget {
  const FixerDrawerFooter({
    super.key,
    required this.theme,
  });

  final ThemeData theme;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Text(
        'v1.0.0 • Quick Pitch App',
        style: TextStyle(color: theme.hintColor, fontSize: 12),
      ),
    );
  }
}
