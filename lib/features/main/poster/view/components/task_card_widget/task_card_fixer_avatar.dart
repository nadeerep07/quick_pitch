import 'package:flutter/material.dart';

class TaskCardFixerAvatar extends StatelessWidget {
  const TaskCardFixerAvatar({
    super.key,
    required this.context,
  });

  final BuildContext context;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 24,
      height: 24,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
          color: Theme.of(context).colorScheme.primary.withValues(alpha: .2),
          width: 1,
        ),
      ),
      child: ClipOval(
        child: Image.asset(
          'assets/images/avatar_photo_placeholder.jpg',
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}
