import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quick_pitch_app/features/fixer_work_selection/model/work_request_model.dart';
import 'package:quick_pitch_app/features/hired_works/view/widgets/payment_option/hire_payment_content.dart';
import 'package:quick_pitch_app/features/hired_works/viewmodel/hire_payments/cubit/hire_payment_cubit.dart';
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
    if (hireRequest.status != HireRequestStatus.completed)
      return const SizedBox.shrink();

    return BlocProvider(
      create: (_) => HirePaymentCubit(HirePaymentService()),
      child: HirePaymentContent(
        hireRequest: hireRequest,
        userPhone: userPhone,
        userName: userName,
        onPaymentCompleted: onPaymentCompleted,
        onPaymentDeclined: onPaymentDeclined,
      ),
    );
  }
}
