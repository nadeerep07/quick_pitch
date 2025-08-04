import 'package:flutter/material.dart';

class TaskCardImageOverlay extends StatelessWidget {
  const TaskCardImageOverlay({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned.fill(
      child: Container(
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.transparent,
              Colors.black.withValues(alpha: 0.3),
            ],
          ),
        ),
      ),
    );
  }
}
