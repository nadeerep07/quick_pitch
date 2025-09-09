import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quick_pitch_app/core/config/responsive.dart';
import 'package:quick_pitch_app/features/fixer_work_selection/model/work_request_model.dart';
import 'package:quick_pitch_app/features/hired_works/viewmodel/hire_payments/cubit/hire_payment_cubit.dart';
import 'package:quick_pitch_app/features/payment/view/payment_confirmation_dialog.dart';
import 'package:quick_pitch_app/features/payment/components/razorpay_config.dart';
import 'package:quick_pitch_app/features/payment/service/hire_payment_services.dart';

class HirePaymentSection extends StatelessWidget {
  final HireRequest hireRequest;
  final String userPhone;
  final String userName;
  final VoidCallback? onPaymentCompleted;
  final VoidCallback? onPaymentDeclined;

  const HirePaymentSection({
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

    if (hireRequest.status != HireRequestStatus.completed) {
      return const SizedBox.shrink();
    }

    return BlocProvider(
      create: (_) => HirePaymentCubit(HirePaymentService()),
      child: BlocConsumer<HirePaymentCubit, HirePaymentState>(
        listener: (context, state) {
          if (state is HirePaymentSuccess) {
            _showSuccessDialog(context, state.transactionId, state.amount);
            onPaymentCompleted?.call();
          } else if (state is HirePaymentDeclined) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text("Payment request declined"), backgroundColor: Colors.orange),
            );
            onPaymentDeclined?.call();
          } else if (state is HirePaymentFailure) {
            _showErrorDialog(context, state.message);
          }
        },
        builder: (context, state) {
          final isProcessing = state is HirePaymentProcessing;

          return Card(
            elevation: 2,
            color: _getBackgroundColor(hireRequest.paymentStatus!),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
              side: BorderSide(color: _getBorderColor(hireRequest.paymentStatus!), width: 1),
            ),
            child: Padding(
              padding: EdgeInsets.all(res.wp(4)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildHeader(res, theme, hireRequest),
                  SizedBox(height: res.hp(2)),
                  _buildContent(context, res, theme, isProcessing),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  // ---------------- UI Parts ---------------- //

  Widget _buildHeader(Responsive res, ThemeData theme, HireRequest hireRequest) {
    return Row(
      children: [
        Icon(_getStatusIcon(hireRequest.paymentStatus!),
            color: _getStatusColor(hireRequest.paymentStatus!), size: res.wp(6)),
        SizedBox(width: res.wp(3)),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Payment Status',
                  style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
              Text(
                _getStatusText(hireRequest.paymentStatus!),
                style: theme.textTheme.bodySmall?.copyWith(
                  color: _getStatusColor(hireRequest.paymentStatus!),
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
              color: _getStatusColor(hireRequest.paymentStatus!).withOpacity(0.1),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: _getStatusColor(hireRequest.paymentStatus!).withOpacity(0.3)),
            ),
            child: Text(
              '₹${_getDisplayAmount(hireRequest).toStringAsFixed(0)}',
              style: theme.textTheme.bodySmall?.copyWith(
                color: _getStatusColor(hireRequest.paymentStatus!),
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildContent(BuildContext context, Responsive res, ThemeData theme, bool isProcessing) {
    switch (hireRequest.paymentStatus) {
      case 'requested':
        return _buildPaymentRequestedContent(context, res, theme, isProcessing);
      case 'completed':
        return _buildPaymentCompletedContent(res, theme);
      case 'declined':
        return _buildPaymentDeclinedContent(context, res, theme, isProcessing);
      default:
        return _buildNoPaymentContent(context, res, theme, isProcessing);
    }
  }

  Widget _buildPaymentRequestedContent(BuildContext context, Responsive res, ThemeData theme, bool isProcessing) {
    return Column(
      children: [
        Container(
          padding: EdgeInsets.all(res.wp(3)),
          decoration: BoxDecoration(
            color: Colors.orange[50],
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.orange[200]!),
          ),
          child: Row(
            children: [
              Icon(Icons.payment, color: Colors.orange[600], size: res.wp(5)),
              SizedBox(width: res.wp(3)),
              Expanded(
                child: Text("Payment Requested", style: theme.textTheme.bodyMedium),
              ),
            ],
          ),
        ),
        SizedBox(height: res.hp(1.5)),
        Row(
          children: [
            Expanded(
              child: OutlinedButton.icon(
                onPressed: isProcessing
                    ? null
                    : () async {
                        final reason = await _showDeclineReasonDialog(context);
                        if (reason != null && reason.isNotEmpty) {
                          context.read<HirePaymentCubit>().declinePayment(
                                hireRequestId: hireRequest.id,
                                reason: reason,
                              );
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
                    : () => _showPaymentConfirmationDialog(context),
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

  Widget _buildPaymentCompletedContent(Responsive res, ThemeData theme) {
    return Container(
      padding: EdgeInsets.all(res.wp(3)),
      decoration: BoxDecoration(color: Colors.green[50], borderRadius: BorderRadius.circular(8), border: Border.all(color: Colors.green[200]!)),
      child: Row(
        children: [
          Icon(Icons.check_circle, color: Colors.green[600], size: res.wp(5)),
          SizedBox(width: res.wp(3)),
          Expanded(child: Text("Payment Completed", style: theme.textTheme.bodyMedium)),
        ],
      ),
    );
  }

  Widget _buildPaymentDeclinedContent(BuildContext context, Responsive res, ThemeData theme, bool isProcessing) {
    return Column(
      children: [
        Container(
          padding: EdgeInsets.all(res.wp(3)),
          decoration: BoxDecoration(color: Colors.red[50], borderRadius: BorderRadius.circular(8), border: Border.all(color: Colors.red[200]!)),
          child: Row(
            children: [
              Icon(Icons.cancel, color: Colors.red[600], size: res.wp(5)),
              SizedBox(width: res.wp(3)),
              Expanded(child: Text("Payment Declined", style: theme.textTheme.bodyMedium)),
            ],
          ),
        ),
        SizedBox(height: res.hp(1.5)),
        ElevatedButton.icon(
          onPressed: isProcessing ? null : () => _showPaymentConfirmationDialog(context),
          icon: isProcessing
              ? SizedBox(width: res.wp(4), height: res.wp(4), child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
              : Icon(Icons.payment, size: res.wp(4)),
          label: Text(isProcessing ? 'Processing...' : 'Pay Original Amount'),
        ),
      ],
    );
  }

  Widget _buildNoPaymentContent(BuildContext context, Responsive res, ThemeData theme, bool isProcessing) {
    return Column(
      children: [
        Container(
          padding: EdgeInsets.all(res.wp(3)),
          decoration: BoxDecoration(color: Colors.blue[50], borderRadius: BorderRadius.circular(8), border: Border.all(color: Colors.blue[200]!)),
          child: Row(
            children: [
              Icon(Icons.info_outline, color: Colors.blue[600], size: res.wp(5)),
              SizedBox(width: res.wp(3)),
              Expanded(child: Text("Task completed successfully. Make payment to the fixer.", style: theme.textTheme.bodyMedium)),
            ],
          ),
        ),
        SizedBox(height: res.hp(1.5)),
        ElevatedButton.icon(
          onPressed: isProcessing ? null : () => _showPaymentConfirmationDialog(context),
          icon: isProcessing
              ? SizedBox(width: res.wp(4), height: res.wp(4), child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
              : Icon(Icons.payment, size: res.wp(4)),
          label: Text(isProcessing ? 'Processing...' : 'Pay ₹${hireRequest.workAmount.toStringAsFixed(0)}'),
        ),
      ],
    );
  }

  // ---------------- Dialogs ---------------- //

  void _showPaymentConfirmationDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => PaymentConfirmationDialog(
        paymentType: PaymentType.hireRequest,
        hireRequest: hireRequest,
        razorpayKeyId: RazorpayConfig.keyId,
        userPhone: userPhone,
        userName: userName,
        isFromRequest: hireRequest.hasPaymentRequest,
        onPaymentSuccess: (paymentId, amount) {
          Navigator.of(context).pop();
          context.read<HirePaymentCubit>().completePayment(
                hireRequestId: hireRequest.id,
                amount: amount,
                transactionId: paymentId,
              );
        },
        onPaymentError: (error) => _showErrorDialog(context, error),
      ),
    );
  }

  Future<String?> _showDeclineReasonDialog(BuildContext context) async {
    String reason = '';
    return showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Decline Payment'),
        content: TextField(
          onChanged: (value) => reason = value,
          decoration: const InputDecoration(hintText: 'Enter reason...', border: OutlineInputBorder()),
          maxLines: 3,
        ),
        actions: [
          TextButton(onPressed: () => Navigator.of(context).pop(), child: const Text('Cancel')),
          ElevatedButton(onPressed: () => Navigator.of(context).pop(reason), child: const Text('Decline')),
        ],
      ),
    );
  }

  void _showSuccessDialog(BuildContext context, String paymentId, double amount) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        content: Column(mainAxisSize: MainAxisSize.min, children: [
          Icon(Icons.check_circle, color: Colors.green, size: 60),
          SizedBox(height: 16),
          Text('Payment Successful!', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          SizedBox(height: 8),
          Text('Payment ID: $paymentId'),
          Text('Amount: ₹${amount.toStringAsFixed(2)}'),
        ]),
        actions: [TextButton(onPressed: () => Navigator.of(context).pop(), child: const Text('OK'))],
      ),
    );
  }

  void _showErrorDialog(BuildContext context, String error) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        content: Column(mainAxisSize: MainAxisSize.min, children: [
          Icon(Icons.error, color: Colors.red, size: 60),
          SizedBox(height: 16),
          Text('Payment Failed', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          SizedBox(height: 8),
          Text(error),
        ]),
        actions: [
          TextButton(onPressed: () => Navigator.of(context).pop(), child: const Text('OK')),
          TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                _showPaymentConfirmationDialog(context);
              },
              child: const Text('Retry')),
        ],
      ),
    );
  }

  // ---------------- Helpers ---------------- //

  Color _getBackgroundColor(String status) {
    switch (status) {
      case 'requested':
        return Colors.orange[50]!;
      case 'completed':
        return Colors.green[50]!;
      case 'declined':
        return Colors.red[50]!;
      default:
        return Colors.blue[50]!;
    }
  }

  Color _getBorderColor(String status) {
    switch (status) {
      case 'requested':
        return Colors.orange[200]!;
      case 'completed':
        return Colors.green[200]!;
      case 'declined':
        return Colors.red[200]!;
      default:
        return Colors.blue[200]!;
    }
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'requested':
        return Colors.orange[600]!;
      case 'completed':
        return Colors.green[600]!;
      case 'declined':
        return Colors.red[600]!;
      default:
        return Colors.blue[600]!;
    }
  }

  IconData _getStatusIcon(String status) {
    switch (status) {
      case 'requested':
        return Icons.payment;
      case 'completed':
        return Icons.check_circle;
      case 'declined':
        return Icons.cancel;
      default:
        return Icons.account_balance_wallet;
    }
  }

  String _getStatusText(String status) {
    switch (status) {
      case 'requested':
        return 'Payment Requested';
      case 'completed':
        return 'Payment Completed';
      case 'declined':
        return 'Payment Declined';
      default:
        return 'Payment Pending';
    }
  }

  double _getDisplayAmount(HireRequest hireRequest) {
    if (hireRequest.paidAmount != null) {
      return hireRequest.paidAmount!;
    }
    return hireRequest.effectivePaymentAmount;
  }
}
