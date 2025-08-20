import 'package:flutter/material.dart';

class DragHandle extends StatelessWidget {
  final bool isDarkMode;
  const DragHandle({super.key, required this.isDarkMode});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: 48,
        height: 4,
        decoration: BoxDecoration(
          color: isDarkMode ? Colors.grey[600] : Colors.grey[300],
          borderRadius: BorderRadius.circular(2),
        ),
      ),
    );
  }
}
