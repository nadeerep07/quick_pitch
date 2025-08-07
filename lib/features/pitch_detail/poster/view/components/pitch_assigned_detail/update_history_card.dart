import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class UpdateHistoryCard extends StatelessWidget {
  final Map<String, dynamic> update;

  const UpdateHistoryCard({super.key, required this.update});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final message = update['message'] ?? '';
    final timestamp = (update['createdAt'] as Timestamp?)?.toDate();
    return Card(
      elevation: 2,
      margin: EdgeInsets.zero,
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: 16,
                  backgroundColor: theme.colorScheme.primaryContainer,
                  child: Icon(Icons.person, size: 16, color: theme.colorScheme.onPrimaryContainer),
                ),
                const SizedBox(width: 8),
                Text(
                  "Update",
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurface.withValues(alpha: .8),
                  ),
                ),
                const Spacer(),
                Text(
                  timestamp != null
                      ? DateFormat('MMM d, y • h:mm a').format(timestamp)
                      : "Unknown date",
                  style: theme.textTheme.labelSmall?.copyWith(
                    color: theme.colorScheme.onSurface.withValues(alpha: .6),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(message, style: theme.textTheme.bodyMedium),
          ],
        ),
      ),
    );
  }
}
