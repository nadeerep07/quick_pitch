import 'package:flutter/material.dart';

class ExploreErrorView extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;

  const ExploreErrorView({
    super.key,
    required this.message,
    required this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.error_outline, size: 64, color: Colors.grey[400]),
          const SizedBox(height: 16),
          Text(
            'Something went wrong',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: Colors.grey[600]),
          ),
          const SizedBox(height: 8),
          Text(message, textAlign: TextAlign.center, style: TextStyle(fontSize: 14, color: Colors.grey[500])),
          const SizedBox(height: 24),
          ElevatedButton(onPressed: onRetry, child: const Text('Try Again')),
        ],
      ),
    );
  }
}
