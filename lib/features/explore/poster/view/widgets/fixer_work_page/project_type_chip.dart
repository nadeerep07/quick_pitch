// Updated FixerWorksPage

import 'dart:ui';
import 'package:flutter/material.dart';

class ProjectTypeChip extends StatelessWidget {
  const ProjectTypeChip({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.blue[100]!, Colors.blue[50]!],
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: Colors.blue.withOpacity(0.2),
          width: 1,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.work_outline_rounded,
            size: 14,
            color: Colors.blue[700],
          ),
          const SizedBox(width: 6),
          Text(
            'Completed Project',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: Colors.blue[700],
            ),
          ),
        ],
      ),
    );
  }
}
