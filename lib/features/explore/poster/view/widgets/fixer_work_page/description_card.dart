// Updated FixerWorksPage

import 'package:flutter/material.dart';

class DescriptionCard extends StatelessWidget {
  final String description;

  const DescriptionCard({super.key, required this.description});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Colors.grey.withOpacity(0.1),
          width: 1,
        ),
      ),
      child: Text(
        description,
        style: TextStyle(
          fontSize: 15,
          color: Colors.grey[700],
          height: 1.6,
          letterSpacing: 0.1,
        ),
      ),
    );
  }
}
