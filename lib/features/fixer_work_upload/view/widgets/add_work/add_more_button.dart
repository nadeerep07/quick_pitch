import 'package:flutter/material.dart';

class AddMoreButton extends StatelessWidget {
  final ThemeData theme;
  final bool isLoading;
  final VoidCallback onPickImages;

  const AddMoreButton({super.key, 
    required this.theme,
    required this.isLoading,
    required this.onPickImages,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: isLoading ? null : onPickImages,
      child: Container(
        width: 80,
        height: 80,
        decoration: BoxDecoration(
          border: Border.all(
            color: theme.primaryColor.withOpacity(0.3),
            width: 1.5,
            style: BorderStyle.solid,
          ),
          borderRadius: BorderRadius.circular(12),
          color: theme.primaryColor.withOpacity(0.05),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.add_rounded, color: theme.primaryColor, size: 24),
            const SizedBox(height: 4),
            Text(
              'Add',
              style: TextStyle(
                color: theme.primaryColor,
                fontSize: 10,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
