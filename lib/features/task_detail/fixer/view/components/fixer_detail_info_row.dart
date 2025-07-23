import 'package:flutter/material.dart';
import 'package:quick_pitch_app/core/config/responsive.dart';

class FixerDetailInfoRow extends StatelessWidget {
  const FixerDetailInfoRow({
    super.key,
    required this.label,
    required this.value,
    required this.res,
  });

  final String label;
  final String value;
  final Responsive res;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(label, style: TextStyle(fontSize: res.sp(13), fontWeight: FontWeight.w600)),
        SizedBox(width: res.wp(2)),
        Expanded(child: Text(value, style: TextStyle(fontSize: res.sp(13)), overflow: TextOverflow.ellipsis)),
      ],
    );
  }
}
