import 'package:flutter/material.dart';
import 'package:quick_pitch_app/core/config/responsive.dart';
import 'package:quick_pitch_app/features/fixer_work_selection/model/work_request_model.dart';
import 'package:quick_pitch_app/features/hired_works/utils/payment_status_utils.dart';

/// -------------------- PAYMENT HEADER -------------------- ///
class PaymentHeader extends StatelessWidget {
  final HireRequest hireRequest;
  const PaymentHeader({super.key, required this.hireRequest});

  @override
  Widget build(BuildContext context) {
    final res = Responsive(context);
    final theme = Theme.of(context);
    final status = hireRequest.paymentStatus ?? 'pending';

    return Row(
      children: [
        Icon(PaymentStatusUtils.statusIcon(status),
            color: PaymentStatusUtils.statusColor(status), size: res.wp(6)),
        SizedBox(width: res.wp(3)),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Payment Status',
                  style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
              Text(
                PaymentStatusUtils.statusText(status),
                style: theme.textTheme.bodySmall?.copyWith(
                  color: PaymentStatusUtils.statusColor(status),
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
        if (hireRequest.hasPaymentRequest || hireRequest.isPaymentCompleted)
          Container(
            padding: EdgeInsets.symmetric(horizontal: res.wp(3), vertical: res.hp(0.5)),
            decoration: BoxDecoration(
              color: PaymentStatusUtils.statusColor(status).withValues(alpha:0.1),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: PaymentStatusUtils.statusColor(status).withValues(alpha:0.3),
              ),
            ),
            child: Text(
              '₹${(hireRequest.paidAmount ?? hireRequest.effectivePaymentAmount).toStringAsFixed(0)}',
              style: theme.textTheme.bodySmall?.copyWith(
                color: PaymentStatusUtils.statusColor(status),
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
      ],
    );
  }
}

