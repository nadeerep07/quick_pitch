import 'package:flutter/material.dart';
import 'package:quick_pitch_app/core/config/responsive.dart';

class SectionCard extends StatelessWidget {
  const SectionCard({
    super.key,
    required this.title,
    required this.value,
    required this.res,
  });

  final String title;
  final String value;
  final Responsive res;

  @override
  Widget build(BuildContext context) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: TextStyle(fontSize: res.sp(16), fontWeight: FontWeight.w600)),
          if (value.isNotEmpty) ...[
            const SizedBox(height: 4),
            Text(value, style: TextStyle(fontSize: res.sp(14))),
          ]
        ],
      );
}
