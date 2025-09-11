
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quick_pitch_app/core/config/responsive.dart';
import 'package:quick_pitch_app/features/fixer_work_selection/model/work_request_model.dart';
import 'package:quick_pitch_app/features/payment/view/payment_confirmation_dialog.dart';
import 'package:quick_pitch_app/features/payment/viewmodel/cubit/payment_cubit.dart';
import 'package:quick_pitch_app/features/payment/widgets/payment_build_actions.dart';
import 'package:quick_pitch_app/features/payment/widgets/payment_build_header.dart';
import 'package:quick_pitch_app/features/payment/widgets/payment_confirmation_dialog/dialog_description.dart';
import 'package:quick_pitch_app/features/payment/widgets/payment_confirmation_dialog/dialog_details.dart';
import 'package:quick_pitch_app/features/payment/widgets/payment_confirmation_dialog/dialog_title.dart';
import 'package:quick_pitch_app/features/payment/widgets/payment_security_info.dart';
import 'package:quick_pitch_app/features/task_pitching/model/pitch_model.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';

class UnifiedPaymentConfirmationView extends StatefulWidget {
  final PaymentType paymentType;
  final PitchModel? pitch;
  final HireRequest? hireRequest;
  final Function(String paymentId, double amount) onPaymentSuccess;
  final Function(String error) onPaymentError;
  final bool isFromRequest;
  final String razorpayKeyId;
  final String userPhone;
  final String userName;

  const UnifiedPaymentConfirmationView({
    required this.paymentType,
    this.pitch,
    this.hireRequest,
    required this.onPaymentSuccess,
    required this.onPaymentError,
    required this.isFromRequest,
    required this.razorpayKeyId,
    required this.userPhone,
    required this.userName,
  });

  @override
  State<UnifiedPaymentConfirmationView> createState() =>
      _UnifiedPaymentConfirmationViewState();
}

class _UnifiedPaymentConfirmationViewState extends State<UnifiedPaymentConfirmationView> {
  late Razorpay _razorpay;

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
    context.read<PaymentCubit>().stopProcessing();
    Navigator.of(context).pop();
    widget.onPaymentSuccess(response.paymentId!, _getPaymentAmount());
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    context.read<PaymentCubit>().stopProcessing();
    widget.onPaymentError(response.message ?? 'Payment failed');
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    context.read<PaymentCubit>().stopProcessing();
    widget.onPaymentError('External wallet payment cancelled');
  }

  double _getPaymentAmount() {
    if (widget.paymentType == PaymentType.pitch) {
      return widget.isFromRequest
          ? (widget.pitch!.requestedPaymentAmount ?? widget.pitch!.budget)
          : widget.pitch!.budget;
    } else {
      return widget.isFromRequest
          ? widget.hireRequest!.effectivePaymentAmount
          : widget.hireRequest!.workAmount;
    }
  }

  String _getTaskTitle() {
    if (widget.paymentType == PaymentType.pitch) {
      return widget.pitch!.pitchText ?? 'Pitch Payment';
    } else {
      return widget.hireRequest!.workTitle;
    }
  }

  String _getTaskId() {
    if (widget.paymentType == PaymentType.pitch) {
      return widget.pitch!.id;
    } else {
      return widget.hireRequest!.id;
    }
  }

  void _initiatePayment() {
    context.read<PaymentCubit>().startProcessing();

    final paymentAmount = _getPaymentAmount();
    final amountInPaise = (paymentAmount * 100).toInt();
    final taskTitle = _getTaskTitle();
    final taskId = _getTaskId();

    var options = {
      'key': widget.razorpayKeyId,
      'amount': amountInPaise,
      'currency': 'INR',
      'name': 'QuickPitch',
      'description': widget.isFromRequest
          ? 'Payment for task: $taskTitle'
          : 'Task completion payment: $taskTitle',
      'prefill': {'contact': widget.userPhone, 'name': widget.userName},
      'theme': {'color': '#4CAF50'},
      'notes': {
        'task_id': taskId,
        'payment_type': widget.isFromRequest ? 'request_approval' : 'task_payment',
        'task_type': widget.paymentType.name,
      },
    };

    try {
      _razorpay.open(options);
    } catch (e) {
      context.read<PaymentCubit>().stopProcessing();
      widget.onPaymentError('Error opening payment gateway: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final res = Responsive(context);
    final theme = Theme.of(context);
    final paymentAmount = _getPaymentAmount();

    return BlocBuilder<PaymentCubit, PaymentState>(
      builder: (context, state) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          child: Padding(
            padding: EdgeInsets.all(res.wp(6)),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                PaymentBuildHeader(res: res),
                SizedBox(height: res.hp(2)),
                DialogTitle(isFromRequest: widget.isFromRequest, theme: theme),
                SizedBox(height: res.hp(1)),
                DialogDescription(
                  isFromRequest: widget.isFromRequest,
                  paymentType: widget.paymentType,
                  theme: theme,
                ),
                SizedBox(height: res.hp(3)),
                DialogDetails(
                  taskTitle: _getTaskTitle(),
                  paymentAmount: paymentAmount,
                  pitch: widget.pitch,
                  hireRequest: widget.hireRequest,
                  paymentType: widget.paymentType,
                  isFromRequest: widget.isFromRequest,
                  res: res,
                  theme: theme,
                ),
                SizedBox(height: res.hp(3)),
                PaymentSecurityInfo(res: res, theme: theme),
                SizedBox(height: res.hp(3)),
                PaymentBuildActions(
                  res: res,
                  isProcessing: state.isProcessing,
                  onCancel: () => Navigator.of(context).pop(),
                  onConfirm: _initiatePayment,
                  isFromRequest: widget.isFromRequest,
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
