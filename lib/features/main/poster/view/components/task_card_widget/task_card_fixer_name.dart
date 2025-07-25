import 'package:flutter/material.dart';

class TaskCardFixerName extends StatelessWidget {
  const TaskCardFixerName({
    super.key,
    required this.fixerName,
    required this.context,
  });

  final String fixerName;
  final BuildContext context;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Text(
        fixerName,
        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Colors.grey[700],
            ),
        overflow: TextOverflow.ellipsis,
      ),
    );
  }
}
