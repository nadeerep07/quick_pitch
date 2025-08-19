import 'package:flutter/material.dart';

class HeaderSection extends StatelessWidget {
  final ThemeData theme;
  final bool isDarkMode;
  final Color primaryColor;

  const HeaderSection({super.key, 
    required this.theme,
    required this.isDarkMode,
    required this.primaryColor,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned(
          right: 0,
          top: -10,
          child: Icon(
            Icons.auto_awesome,
            size: 40,
            color: primaryColor.withOpacity(0.3),
          ),
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Build Your Skills",
              style: theme.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.w700,
                color: isDarkMode ? Colors.white : Colors.black87,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              "Select the skills you want to highlight",
              style: theme.textTheme.bodyMedium?.copyWith(
                color: isDarkMode ? Colors.grey[400] : Colors.grey[600],
              ),
            ),
          ],
        ),
      ],
    );
  }
}
