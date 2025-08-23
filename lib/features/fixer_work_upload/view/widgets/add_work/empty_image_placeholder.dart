import 'package:flutter/material.dart';

class EmptyImagePlaceholder extends StatelessWidget {
  final ThemeData theme;
  final bool isLoading;
  final VoidCallback onPickImages;

  const EmptyImagePlaceholder({super.key, 
    required this.theme,
    required this.isLoading,
    required this.onPickImages,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: isLoading ? null : onPickImages,
      child: Container(
        height: 100,
        decoration: BoxDecoration(
          border: Border.all(
            color: Colors.grey.shade300,
            style: BorderStyle.solid,
          ),
          borderRadius: BorderRadius.circular(12),
          color: Colors.grey.shade50,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.add_photo_alternate_outlined,
              size: 32,
              color: Colors.grey.shade500,
            ),
            const SizedBox(height: 8),
            Text(
              'Add work images',
              style: TextStyle(
                color: Colors.grey.shade600,
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              'Up to 5 images',
              style: TextStyle(color: Colors.grey.shade500, fontSize: 12),
            ),
          ],
        ),
      ),
    );
  }
}
