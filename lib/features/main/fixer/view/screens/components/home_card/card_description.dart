import 'package:flutter/material.dart';
import 'package:quick_pitch_app/core/config/responsive.dart';

class CardDescription extends StatelessWidget {
  const CardDescription({
    super.key,
    required this.description,
    required this.res,
  });

  final String description;
  final Responsive res;

  @override
  Widget build(BuildContext context) {
    return Text(
      description,
      maxLines: 2,
      overflow: TextOverflow.ellipsis,
      style: TextStyle(
        fontSize: res.sp(12.5),
        color: Colors.black87,
      ),
    );
  }
}
