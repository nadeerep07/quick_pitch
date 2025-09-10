import 'package:flutter/material.dart';
import 'package:quick_pitch_app/core/config/responsive.dart';
import 'package:quick_pitch_app/features/about_app/view/widget/info_row.dart';

class InfoSection extends StatelessWidget {
  final Responsive res;
  const InfoSection({super.key, required this.res});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(res.wp(4)),
      decoration: BoxDecoration(
        color: const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(res.wp(4)),
        border: Border.all(color: const Color(0xFFE5E7EB), width: 1),
      ),
      child: Column(
        children: [
          InfoRow(res: res, icon: Icons.info_outline_rounded, label: 'Version', value: 'v1.0.0'),
          SizedBox(height: res.hp(2)),
          InfoRow(res: res, icon: Icons.person_outline_rounded, label: 'Developed by', value: 'Nadeer'),
          SizedBox(height: res.hp(2)),
          InfoRow(res: res, icon: Icons.email_outlined, label: 'Contact', value: 'support@quickpitch.com'),
        ],
      ),
    );
  }
}
