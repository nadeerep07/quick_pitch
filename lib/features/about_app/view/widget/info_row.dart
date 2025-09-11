import 'package:flutter/material.dart';
import 'package:quick_pitch_app/core/config/responsive.dart';

class InfoRow extends StatelessWidget {
  final Responsive res;
  final IconData icon;
  final String label;
  final String value;
  const InfoRow({super.key, 
    required this.res,
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          padding: EdgeInsets.all(res.wp(2)),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(res.wp(2)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 4,
                offset: const Offset(0, 1),
              ),
            ],
          ),
          child: Icon(icon, color: const Color(0xFF667EEA), size: res.sp(16)),
        ),
        SizedBox(width: res.wp(3)),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                  fontSize: res.sp(10),
                  color: const Color(0xFF9CA3AF),
                  fontWeight: FontWeight.w500,
                ),
              ),
              SizedBox(height: res.hp(0.5)),
              Text(
                value,
                style: TextStyle(
                  fontSize: res.sp(12),
                  color: const Color(0xFF374151),
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
