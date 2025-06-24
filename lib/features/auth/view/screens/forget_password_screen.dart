import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:quick_pitch_app/core/errors/auth_error_mapper.dart';
import 'package:quick_pitch_app/features/auth/view/components/custom_button.dart';
import 'package:quick_pitch_app/features/auth/view/components/custom_dialog.dart';
import 'package:quick_pitch_app/features/auth/view/components/form_field.dart';
import 'package:quick_pitch_app/features/auth/viewmodel/bloc/auth_bloc.dart';
import 'package:quick_pitch_app/features/auth/viewmodel/cubit/submisson_cubit.dart';
import 'package:quick_pitch_app/features/auth/viewmodel/forget_password_viewmodel.dart';
import 'package:quick_pitch_app/shared/config/responsive.dart';
import 'package:quick_pitch_app/shared/theme/app_colors.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  late final ForgotPasswordViewModel viewModel;

  @override
  void initState() {
    super.initState();
    viewModel = ForgotPasswordViewModel();
  }

  @override
  Widget build(BuildContext context) {
    final res = Responsive(context);

    return BlocListener<AuthBloc, AuthState>(
      listenWhen:
          (previous, current) =>
              current is AuthFailure || current is PasswordResetSent,
      listener: (context, state) {
        context.read<SubmissionCubit>().stop();

        if (state is PasswordResetSent) {
          showDialog(
            context: context,
            builder:
                (_) => CustomDialog(
                  title: "Email Sent",
                  message: "A password reset link has been sent to your email.",
                  icon: Icons.check_circle_outline,
                  iconColor: Colors.green,
                  onConfirm: () => Navigator.of(context).pop(),
                ),
          );
        } else if (state is AuthFailure) {
          final errorMsg = mapFirebaseError(state.error); 
          showDialog(
            context: context,
            builder:
                (_) => CustomDialog(
                  title: "Error",
                  message: errorMsg,
                  icon: Icons.error_outline,
                  iconColor: Colors.red,
                  onConfirm: () => Navigator.of(context).pop(),
                ),
          );
        }
      },

      child: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/signup.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: Scaffold(
          backgroundColor: Colors.transparent,
          body: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: res.wp(5),
              vertical: res.hp(10),
            ),
            child: Column(
              
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(height: res.hp(5)),
                Text(
                  "Forgot Password?",
                  style: GoogleFonts.inter(
                    fontSize: res.wp(8),
                    fontWeight: FontWeight.w600,
                    color: AppColors.secondaryText,
                  ),
                ),
                 SizedBox(height: res.hp(4)),
                Text(
                  "Enter your registered email address below and\nwe'll send you a link to reset your password.",
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: .85),
                    fontSize: 14,
                    height: 1.4,
                  ),
                ),
                SizedBox(height: res.hp(3)),
                CustomTextField(
                  icon: Icons.email_outlined,
                  controller: viewModel.emailController,
                  hint: 'Enter your email',
                ),
                SizedBox(height: res.hp(3)),
                BlocBuilder<SubmissionCubit, bool>(
                  builder: (context, isLoading) {
                    return CustomButton(
                      text: 'Send Reset Link',
                      isLoading: isLoading,
                      onPressed: () => viewModel.sendResetLink(context),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
