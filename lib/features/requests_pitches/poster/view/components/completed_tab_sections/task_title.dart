import 'package:flutter/material.dart';

class TaskTitle extends StatelessWidget {
  final String title;
  const TaskTitle({required this.title});

  @override
  Widget build(BuildContext context) => Text(
        title,
        style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w700,
              color: Colors.grey.shade800,
              height: 1.3,
            ),
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
      );
}
