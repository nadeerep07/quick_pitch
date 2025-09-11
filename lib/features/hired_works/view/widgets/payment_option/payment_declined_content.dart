import 'package:flutter/material.dart';
import 'package:quick_pitch_app/core/config/responsive.dart';
import 'package:quick_pitch_app/features/fixer_work_selection/model/work_request_model.dart';
import 'package:quick_pitch_app/features/hired_works/view/widgets/payment_option/payment_dialogs.dart';
import 'package:quick_pitch_app/features/hired_works/view/widgets/payment_option/status_box.dart';
import 'package:quick_pitch_app/features/hired_works/viewmodel/hire_payments/cubit/hire_payment_cubit.dart';

/// -------------------- PAYMENT DECLINED -------------------- ///
class PaymentDeclinedContent extends StatelessWidget {
  final HireRequest hireRequest;
  final String userPhone;
  final String userName;
  final HirePaymentCubit cubit;
  final bool isProcessing;

  const PaymentDeclinedContent({
    super.key,
    required this.hireRequest,
    required this.userPhone,
    required this.userName,
    required this.cubit,
    required this.isProcessing,
  });

  @override
  Widget build(BuildContext context) {
    final res = Responsive(context);

    return Column(
      children: [
        StatusBox(
          color: Colors.red[50]!,
          borderColor: Colors.red[200]!,
          icon: Icons.cancel,
          iconColor: Colors.red[600]!,
          text: 'Payment Declined',
        ),
        SizedBox(height: res.hp(1.5)),
        ElevatedButton.icon(
          onPressed: isProcessing
              ? null
              : () => PaymentDialogs.showConfirmation(context, hireRequest, userPhone, userName, cubit),
          icon: isProcessing
              ? SizedBox(width: res.wp(4), height: res.wp(4), child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
              : Icon(Icons.payment, size: res.wp(4)),
          label: Text(isProcessing ? 'Processing...' : 'Pay Original Amount'),
        ),
      ],
    );
  }
}

