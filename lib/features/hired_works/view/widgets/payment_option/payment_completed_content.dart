import 'package:flutter/material.dart';
import 'package:quick_pitch_app/features/hired_works/view/widgets/payment_option/status_box.dart';


class PaymentCompletedContent extends StatelessWidget {
  const PaymentCompletedContent({super.key});

  @override
  Widget build(BuildContext context) {
  

    return StatusBox(
      color: Colors.green[50]!,
      borderColor: Colors.green[200]!,
      icon: Icons.check_circle,
      iconColor: Colors.green[600]!,
      text: 'Payment Completed',
    );
  }
}

