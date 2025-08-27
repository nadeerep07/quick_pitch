import 'package:flutter/material.dart';
import 'package:quick_pitch_app/core/config/responsive.dart';

/// Reusable Detail Row
class DetailRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final bool isMultiLine;

  const DetailRow({super.key, 
    required this.icon,
    required this.label,
    required this.value,
    this.isMultiLine = false,
  });

  @override
  Widget build(BuildContext context) {
    final res = Responsive(context);

    return Padding(
      padding: EdgeInsets.only(bottom: res.hp(1.5)),
      child: Row(
        crossAxisAlignment:
            isMultiLine ? CrossAxisAlignment.start : CrossAxisAlignment.center,
        children: [
          Icon(icon, size: res.wp(5), color: Colors.grey),
          SizedBox(width: res.wp(3)),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(fontSize: res.sp(12), color: Colors.grey),
                ),
                SizedBox(height: res.hp(0.5)),
                Text(
                  value,
                  style: TextStyle(
                    fontSize: res.sp(14),
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
