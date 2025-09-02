import 'package:flutter/material.dart';
import 'package:quick_pitch_app/features/payment/widgets/payment_build_actions.dart';
import 'package:quick_pitch_app/features/payment/widgets/payment_build_description.dart';
import 'package:quick_pitch_app/features/payment/widgets/payment_build_details.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:quick_pitch_app/core/config/responsive.dart';
import 'package:quick_pitch_app/features/task_pitching/model/pitch_model.dart';
import 'package:quick_pitch_app/features/payment/widgets/payment_build_header.dart';
import 'package:quick_pitch_app/features/payment/widgets/payment_build_title.dart';
import 'package:quick_pitch_app/features/payment/widgets/payment_security_info.dart';

class PaymentConfirmationDialog extends StatefulWidget {
  final PitchModel pitch;
  final Function(String paymentId, double amount) onPaymentSuccess;
  final Function(String error) onPaymentError;
  final bool isFromRequest;
  final String razorpayKeyId;
  final String userPhone;
  final String userName;

  const PaymentConfirmationDialog({
    super.key,
    required this.pitch,
    required this.onPaymentSuccess,
    required this.onPaymentError,
    required this.razorpayKeyId,
    required this.userPhone,
    required this.userName,
    this.isFromRequest = false,
  });

  @override
  State<PaymentConfirmationDialog> createState() =>
      _PaymentConfirmationDialogState();
}

class _PaymentConfirmationDialogState extends State<PaymentConfirmationDialog> {
  late Razorpay _razorpay;
  bool _isProcessing = false;

  @override
  void initState() {
    super.initState();
    _razorpay = Razorpay();
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
  }

  @override
  void dispose() {
    _razorpay.clear();
    super.dispose();
  }

  void _handlePaymentSuccess(PaymentSuccessResponse response) {
    setState(() => _isProcessing = false);
    Navigator.of(context).pop();
    final paymentAmount = widget.isFromRequest
        ? (widget.pitch.requestedPaymentAmount ?? widget.pitch.budget)
        : widget.pitch.budget;
    widget.onPaymentSuccess(response.paymentId!, paymentAmount);
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    setState(() => _isProcessing = false);
    widget.onPaymentError(response.message ?? 'Payment failed');
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    setState(() => _isProcessing = false);
    widget.onPaymentError('External wallet payment cancelled');
  }

  void _initiatePayment() {
    setState(() => _isProcessing = true);

    final paymentAmount = widget.isFromRequest
        ? (widget.pitch.requestedPaymentAmount ?? widget.pitch.budget)
        : widget.pitch.budget;

    final amountInPaise = (paymentAmount * 100).toInt();

    var options = {
      'key': widget.razorpayKeyId,
      'amount': amountInPaise,
      'currency': 'INR',
      'name': 'QuickPitch',
      'description': widget.isFromRequest
          ? 'Payment for task:'
          : 'Task completion payment',
      'prefill': {
        'contact': widget.userPhone,
        'name': widget.userName,
      },
      'theme': {'color': '#4CAF50'},
      'notes': {
        'pitch_id': widget.pitch.id,
        'payment_type':
            widget.isFromRequest ? 'request_approval' : 'task_payment',
      },
    };

    try {
      _razorpay.open(options);
    } catch (e) {
      setState(() => _isProcessing = false);
      widget.onPaymentError('Error opening payment gateway: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final res = Responsive(context);
    final theme = Theme.of(context);
    final paymentAmount = widget.isFromRequest
        ? (widget.pitch.requestedPaymentAmount ?? widget.pitch.budget)
        : widget.pitch.budget;

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Padding(
        padding: EdgeInsets.all(res.wp(6)),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            PaymentBuildHeader(res: res),
            SizedBox(height: res.hp(2)),
            PaymentBuildTitle(widget: widget, theme: theme),
            SizedBox(height: res.hp(1)),
            PaymentBuildDescription(widget: widget, theme: theme),
            SizedBox(height: res.hp(3)),
            PaymentBuildDetails(
              widget: widget,
              res: res,
              theme: theme,
              paymentAmount: paymentAmount,
            ),
            SizedBox(height: res.hp(3)),
            PaymentSecurityInfo(res: res, theme: theme),
            SizedBox(height: res.hp(3)),
            PaymentBuildActions(
              res: res,
              isProcessing: _isProcessing,
              onCancel: () => Navigator.of(context).pop(),
              onConfirm: _initiatePayment,
              isFromRequest: widget.isFromRequest,
            ),
          ],
        ),
      ),
    );
  }
}
