import 'package:flutter/material.dart';
import 'package:quick_pitch_app/core/config/responsive.dart';

/// -------------------- STATUS BOX -------------------- ///
class StatusBox extends StatelessWidget {
  final Color color;
  final Color borderColor;
  final IconData icon;
  final Color iconColor;
  final String text;

  const StatusBox({
    super.key,
    required this.color,
    required this.borderColor,
    required this.icon,
    required this.iconColor,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    final res = Responsive(context);

    return Container(
      padding: EdgeInsets.all(res.wp(3)),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: borderColor),
      ),
      child: Row(
        children: [
          Icon(icon, color: iconColor, size: res.wp(5)),
          SizedBox(width: res.wp(3)),
          Expanded(child: Text(text, style: Theme.of(context).textTheme.bodyMedium)),
        ],
      ),
    );
  }
}

