import 'package:flutter/material.dart';
import 'package:quick_pitch_app/features/fixer_work_selection/model/work_request_model.dart';
import 'package:quick_pitch_app/features/hired_works/view/screens/hired_works_screen.dart';
import 'package:quick_pitch_app/features/hired_works/view/widgets/hired_listing/payment_status_chip.dart';

class HireRequestDetails extends StatelessWidget {
  final HireRequest hireRequest;
  final String userPhone;
  final String userName;

  const HireRequestDetails({required this.hireRequest, required this.userPhone, required this.userName});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Add all the details here (similar to your original modal)
        Text(hireRequest.workTitle, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
        const SizedBox(height: 12),
        PaymentStatusChip(status: hireRequest.paymentStatus ?? 'unknown'),
        // Add rest fields: description, images, amount, times, dates, messages, etc.
      ],
    );
  }
}
