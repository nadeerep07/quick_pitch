import 'package:flutter/material.dart';

class TaskCardTitle extends StatelessWidget {
  const TaskCardTitle({
    super.key,
    required this.title,
    required this.context,
  });

  final String title;
  final BuildContext context;

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: Theme.of(context).textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
            height: 1.3,
          ),
      maxLines: 2,
      overflow: TextOverflow.ellipsis,
    );
  }
}
