import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quick_pitch_app/core/config/responsive.dart';
import 'package:quick_pitch_app/features/fixer_work_selection/model/work_request_model.dart';
import 'package:quick_pitch_app/features/hired_works/utils/payment_status_utils.dart';
import 'package:quick_pitch_app/features/hired_works/view/widgets/payment_option/payment_body.dart';
import 'package:quick_pitch_app/features/hired_works/view/widgets/payment_option/payment_dialogs.dart';
import 'package:quick_pitch_app/features/hired_works/view/widgets/payment_option/payment_header.dart';
import 'package:quick_pitch_app/features/hired_works/viewmodel/hire_payments/cubit/hire_payment_cubit.dart';

/// -------------------- HIRE PAYMENT CONTENT -------------------- ///
class HirePaymentContent extends StatelessWidget {
  final HireRequest hireRequest;
  final String userPhone;
  final String userName;
  final VoidCallback? onPaymentCompleted;
  final VoidCallback? onPaymentDeclined;

  const HirePaymentContent({
    super.key,
    required this.hireRequest,
    required this.userPhone,
    required this.userName,
    this.onPaymentCompleted,
    this.onPaymentDeclined,
  });

  @override
  Widget build(BuildContext context) {
    final res = Responsive(context);
    final theme = Theme.of(context);
    final paymentStatus = hireRequest.paymentStatus ?? 'pending';

    return BlocConsumer<HirePaymentCubit, HirePaymentState>(
      listener: (context, state) {
        if (state is HirePaymentSuccess) {
          PaymentDialogs.showSuccess(context, state.transactionId, state.amount);
          onPaymentCompleted?.call();
        } else if (state is HirePaymentDeclined) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text("Payment request declined"),
              backgroundColor: Colors.orange,
            ),
          );
          onPaymentDeclined?.call();
        } else if (state is HirePaymentFailure) {
          PaymentDialogs.showError(context, state.message, () {
            final cubit = context.read<HirePaymentCubit>();
            PaymentDialogs.showConfirmation(context, hireRequest, userPhone, userName, cubit);
          });
        }
      },
      builder: (context, state) {
        final cubit = context.read<HirePaymentCubit>();
        final isProcessing = state is HirePaymentProcessing;

        return Card(
          elevation: 2,
          color: PaymentStatusUtils.backgroundColor(paymentStatus),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
            side: BorderSide(
              color: PaymentStatusUtils.borderColor(paymentStatus),
              width: 1,
            ),
          ),
          child: Padding(
            padding: EdgeInsets.all(res.wp(4)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                PaymentHeader(hireRequest: hireRequest),
                SizedBox(height: res.hp(2)),
                PaymentBody(
                  hireRequest: hireRequest,
                  userPhone: userPhone,
                  userName: userName,
                  cubit: cubit,
                  isProcessing: isProcessing,
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

