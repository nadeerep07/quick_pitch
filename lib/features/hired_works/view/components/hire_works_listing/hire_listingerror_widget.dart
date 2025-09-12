import 'package:flutter/material.dart';

class HireListingErrorWidget extends StatelessWidget {
  const HireListingErrorWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.error_outline, size: 64, color: Colors.red.shade300),
          const SizedBox(height: 16),
          Text('Error loading hired works', style: TextStyle(fontSize: 18, color: Colors.red.shade700, fontWeight: FontWeight.w500)),
          const SizedBox(height: 8),
          Text('Please try again later', style: TextStyle(fontSize: 14, color: Colors.grey.shade600)),
        ],
      ),
    );
  }
}
