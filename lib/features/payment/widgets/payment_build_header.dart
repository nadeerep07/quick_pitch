import 'package:flutter/material.dart';
import 'package:quick_pitch_app/core/config/responsive.dart';

class PaymentBuildHeader extends StatelessWidget {
  const PaymentBuildHeader({
    super.key,
    required this.res,
  });

  final Responsive res;

  @override
  Widget build(BuildContext context) => Container(
        padding: EdgeInsets.all(res.wp(4)),
        decoration: BoxDecoration(
          color: Colors.green[100],
          shape: BoxShape.circle,
        ),
        child: Icon(Icons.payment, color: Colors.green[600], size: res.wp(8)),
      );
}
