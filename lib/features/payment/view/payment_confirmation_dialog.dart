import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quick_pitch_app/features/payment/view/payment_confirmation_view.dart';
import 'package:quick_pitch_app/features/payment/viewmodel/cubit/payment_cubit.dart';
import 'package:quick_pitch_app/features/task_pitching/model/pitch_model.dart';
import 'package:quick_pitch_app/features/fixer_work_selection/model/work_request_model.dart';


enum PaymentType { pitch, hireRequest }

class PaymentConfirmationDialog extends StatelessWidget {
  final PaymentType paymentType;
  final PitchModel? pitch;
  final HireRequest? hireRequest;
  final Function(String paymentId, double amount) onPaymentSuccess;
  final Function(String error) onPaymentError;
  final bool isFromRequest;
  final String razorpayKeyId;
  final String userPhone;
  final String userName;

  const PaymentConfirmationDialog({
    super.key,
    required this.paymentType,
    this.pitch,
    this.hireRequest,
    required this.onPaymentSuccess,
    required this.onPaymentError,
    required this.razorpayKeyId,
    required this.userPhone,
    required this.userName,
    this.isFromRequest = false,
  }) : assert((paymentType == PaymentType.pitch && pitch != null) ||
               (paymentType == PaymentType.hireRequest && hireRequest != null),
               'Must provide either pitch or hireRequest based on paymentType');

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => PaymentCubit(),
      child: PaymentConfirmationView(
        paymentType: paymentType,
        pitch: pitch,
        hireRequest: hireRequest,
        onPaymentSuccess: onPaymentSuccess,
        onPaymentError: onPaymentError,
        isFromRequest: isFromRequest,
        razorpayKeyId: razorpayKeyId,
        userPhone: userPhone,
        userName: userName,
      ),
    );
  }
}

