import 'package:flutter/material.dart';

class InfoCard extends StatelessWidget {
  const InfoCard({
    super.key,
    required this.title,
    required this.value,
  });

  final String title;
  final String value;

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.only(bottom: 4),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(width: 120, child: Text("$title:", style: const TextStyle(fontWeight: FontWeight.w600))),
            Expanded(child: Text(value, style: const TextStyle(color: Colors.black87))),
          ],
        ),
      );
}
