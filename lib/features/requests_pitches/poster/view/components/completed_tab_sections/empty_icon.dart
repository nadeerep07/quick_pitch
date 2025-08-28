import 'package:flutter/material.dart';

class EmptyIcon extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Container(
        width: 120,
        height: 120,
        decoration:
            BoxDecoration(color: Colors.green.shade50, shape: BoxShape.circle),
        child: Icon(Icons.task_alt_rounded,
            size: 64, color: Colors.green.shade400),
      );
}

