import 'package:flutter/material.dart';

class DateLabel extends StatelessWidget {
  final DateTime date;

  const DateLabel({super.key, required this.date});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Text(
        _formatDate(date),
        style: TextStyle(fontSize: 12, color: Colors.grey[600]),
      ),
    );
  }

  String _formatDate(DateTime timestamp) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final yesterday = today.subtract(const Duration(days: 1));
    final messageDate = DateTime(timestamp.year, timestamp.month, timestamp.day);

    if (messageDate == today) return 'Today';
    if (messageDate == yesterday) return 'Yesterday';
    return '${timestamp.day}/${timestamp.month}/${timestamp.year}';
  }
}
