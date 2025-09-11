import 'package:flutter/material.dart';
import 'package:quick_pitch_app/features/fixer_work_selection/model/work_request_model.dart';
import 'package:quick_pitch_app/features/hired_works/view/widgets/payment_option/payment_completed_content.dart';
import 'package:quick_pitch_app/features/hired_works/view/widgets/payment_option/payment_declined_content.dart';
import 'package:quick_pitch_app/features/hired_works/view/widgets/payment_option/payment_pending_content.dart';
import 'package:quick_pitch_app/features/hired_works/view/widgets/payment_option/payment_requested_content.dart';
import 'package:quick_pitch_app/features/hired_works/viewmodel/hire_payments/cubit/hire_payment_cubit.dart';

/// -------------------- PAYMENT BODY -------------------- ///
class PaymentBody extends StatelessWidget {
  final HireRequest hireRequest;
  final String userPhone;
  final String userName;
  final HirePaymentCubit cubit;
  final bool isProcessing;

  const PaymentBody({
    super.key,
    required this.hireRequest,
    required this.userPhone,
    required this.userName,
    required this.cubit,
    required this.isProcessing,
  });

  @override
  Widget build(BuildContext context) {
    final status = hireRequest.paymentStatus ?? 'pending';
    switch (status) {
      case 'requested':
        return PaymentRequestedContent(
            hireRequest: hireRequest, userPhone: userPhone, userName: userName, cubit: cubit, isProcessing: isProcessing);
      case 'completed':
        return PaymentCompletedContent();
      case 'declined':
        return PaymentDeclinedContent(hireRequest: hireRequest, userPhone: userPhone, userName: userName, cubit: cubit, isProcessing: isProcessing);
      default:
        return PaymentPendingContent(hireRequest: hireRequest, userPhone: userPhone, userName: userName, cubit: cubit, isProcessing: isProcessing);
    }
  }
}

