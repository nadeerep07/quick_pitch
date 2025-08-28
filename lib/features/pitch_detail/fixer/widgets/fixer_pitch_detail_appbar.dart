import 'package:flutter/material.dart';

AppBar buildPitchAppBar(
  BuildContext context,
  ColorScheme colorScheme,
  ThemeData theme,
  bool isAssigned,
  bool isCompleted,
) {
  return AppBar(
    title: Text(
      'Pitch Details',
      style: theme.textTheme.titleLarge?.copyWith(
        fontWeight: FontWeight.w600,
        color: colorScheme.onSurface,
      ),
    ),
    centerTitle: true,
    elevation: 0,
    backgroundColor: Colors.transparent,
    leading: IconButton(
      icon: Icon(Icons.arrow_back, color: colorScheme.onSurface),
      onPressed: () => Navigator.pop(context),
    ),
  );
}
