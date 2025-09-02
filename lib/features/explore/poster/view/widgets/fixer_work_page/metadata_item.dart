// Updated FixerWorksPage

import 'package:flutter/material.dart';

class MetadataItem extends StatelessWidget {
  final IconData icon;
  final String text;
  final MaterialColor color;

  const MetadataItem({super.key, 
    required this.icon,
    required this.text,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: color.withOpacity(0.2),
          width: 1,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 16,
            color: color[700],
          ),
          const SizedBox(width: 8),
          Text(
            text,
            style: TextStyle(
              fontSize: 13,
              color: color[700],
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}