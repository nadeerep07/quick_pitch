import 'package:flutter/material.dart';
import 'package:quick_pitch_app/core/config/responsive.dart';

class FixerDetailInfoCard extends StatelessWidget {
  const FixerDetailInfoCard({
    super.key,
    required this.child,
    required this.res,
  });

  final Widget child;
  final Responsive res;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(res.hp(1.2)),
      margin: EdgeInsets.only(bottom: res.hp(1.2)),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: .1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white.withValues(alpha: .2)),
      ),
      child: child,
    );
  }
}
