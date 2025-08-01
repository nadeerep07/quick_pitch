import 'package:flutter/material.dart';

class HeaderSection extends StatelessWidget {
  final VoidCallback onClear;

  const HeaderSection({super.key, required this.onClear});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text(
          'Advanced Filters',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        Row(
          children: [
            TextButton(
              onPressed: onClear,
              child: const Text(
                'Clear All',
                style: TextStyle(color: Color(0xFF4E5AF2)),
              ),
            ),
            IconButton(
              icon: const Icon(Icons.close),
              onPressed: () => Navigator.pop(context),
            ),
          ],
        ),
      ],
    );
  }
}
