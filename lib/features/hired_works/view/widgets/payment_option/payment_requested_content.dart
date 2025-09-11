import 'package:flutter/material.dart';
import 'package:quick_pitch_app/core/config/responsive.dart';
import 'package:quick_pitch_app/features/fixer_work_selection/model/work_request_model.dart';
import 'package:quick_pitch_app/features/hired_works/view/widgets/payment_option/payment_dialogs.dart';
import 'package:quick_pitch_app/features/hired_works/view/widgets/payment_option/status_box.dart';
import 'package:quick_pitch_app/features/hired_works/viewmodel/hire_payments/cubit/hire_payment_cubit.dart';

/// -------------------- PAYMENT REQUESTED -------------------- ///
class PaymentRequestedContent extends StatelessWidget {
  final HireRequest hireRequest;
  final String userPhone;
  final String userName;
  final HirePaymentCubit cubit;
  final bool isProcessing;

  const PaymentRequestedContent({
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
    final theme = Theme.of(context);

    return Column(
      children: [
        StatusBox(
          color: Colors.orange[50]!,
          borderColor: Colors.orange[200]!,
          icon: Icons.payment,
          iconColor: Colors.orange[600]!,
          text: 'Payment Requested',
        ),
        SizedBox(height: res.hp(1.5)),
        Row(
          children: [
            Expanded(
              child: OutlinedButton.icon(
                onPressed: isProcessing
                    ? null
                    : () async {
                        final reason = await PaymentDialogs.showDeclineReasonDialog(context);
                        if (reason != null && reason.isNotEmpty) {
                          cubit.declinePayment(hireRequestId: hireRequest.id, reason: reason);
                        }
                      },
                icon: Icon(Icons.cancel_outlined, size: res.wp(4)),
                label: Text(isProcessing ? 'Processing...' : 'Decline'),
              ),
            ),
            SizedBox(width: res.wp(3)),
            Expanded(
              flex: 2,
              child: ElevatedButton.icon(
                onPressed: isProcessing
                    ? null
                    : () => PaymentDialogs.showConfirmation(context, hireRequest, userPhone, userName, cubit),
                icon: isProcessing
                    ? SizedBox(width: res.wp(4), height: res.wp(4), child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                    : Icon(Icons.payment, size: res.wp(4)),
                label: Text(isProcessing ? 'Processing...' : 'Pay Now'),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

