import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quick_pitch_app/features/auth/view/components/custom_dialog.dart';
import 'package:quick_pitch_app/features/auth/viewmodel/bloc/auth_bloc.dart';
import 'package:quick_pitch_app/features/auth/viewmodel/cubit/submisson_cubit.dart';

class ForgotPasswordViewModel {
  final TextEditingController emailController = TextEditingController();

  void sendResetLink(BuildContext context) {
    final email = emailController.text.trim();
    if (email.isEmpty || !email.contains('@')) {
      showDialog(
        context: context,
        builder: (_) => const _InvalidEmailDialog(),
      );
      return;
    }

    context.read<SubmissionCubit>().start();
    context.read<AuthBloc>().add(ForgotPasswordRequested(email));
  }
}

class _InvalidEmailDialog extends StatelessWidget {
  const _InvalidEmailDialog();

  @override
  Widget build(BuildContext context) {
    return CustomDialog(
      title: "Invalid Email",
      message: "Please enter a valid email address.",
      icon: Icons.warning_amber,
      iconColor: Colors.orange,
      onConfirm: () => Navigator.of(context).pop(),
    );
  }
}