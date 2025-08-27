import 'package:flutter/material.dart';
import 'package:quick_pitch_app/features/fixer_work_upload/view/widgets/work_upload_main_widgets/add_button.dart';

class SectionHeader extends StatelessWidget {
  final ThemeData theme;
  final bool isOwner;
  final VoidCallback onAddPressed;

  const SectionHeader({super.key, 
    required this.theme,
    required this.isOwner,
    required this.onAddPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            theme.primaryColor.withOpacity(0.1),
            theme.primaryColor.withOpacity(0.05),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: theme.primaryColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  Icons.work_outline,
                  color: theme.primaryColor,
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              Text(
                'Portfolio',
                style: theme.textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: theme.colorScheme.onSurface,
                ),
              ),
            ],
          ),
          if (isOwner) AddButton(theme: theme, onPressed: onAddPressed),
        ],
      ),
    );
  }
}
