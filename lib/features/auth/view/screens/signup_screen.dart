import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:quick_pitch_app/core/errors/auth_error_mapper.dart';
import 'package:quick_pitch_app/features/auth/view/components/custom_dialog.dart';
import 'package:quick_pitch_app/features/auth/view/components/signup_form.dart';
import 'package:quick_pitch_app/features/auth/view/screens/email_verifcation.dart';
import 'package:quick_pitch_app/features/auth/viewmodel/bloc/auth_bloc.dart';
import 'package:quick_pitch_app/features/auth/viewmodel/cubit/submisson_cubit.dart';
import 'package:quick_pitch_app/core/config/responsive.dart';
import 'package:quick_pitch_app/core/config/app_colors.dart';

class SignupScreen extends StatelessWidget {
  const SignupScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final res = Responsive(context);

    return BlocListener<AuthBloc, AuthState>(
      listenWhen:
          (previous, current) =>
              current is AuthFailure || current is AuthSuccess,
      listener: (context, state) {
        context.read<SubmissionCubit>().stop();

        if (state is AuthSuccess) {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(
              builder:
                  (_) => VerificationScreen(
                    email: state.email,
                  ), 
            ),
          );
        } else if (state is AuthFailure) {
         // print(state.error.toString());
          showDialog(
            context: context,
            builder:
                (context) => CustomDialog(
                  title: "Signup Failed",
                  message: mapFirebaseError(state.error),
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
          body: Stack(
            children: [
              Padding(
                padding: EdgeInsets.only(left: res.wp(5), top: res.hp(17)),
                child: Text(
                  'Create\nAccount',
                  style: GoogleFonts.inter(
                    fontSize: res.wp(8),
                    fontWeight: FontWeight.w600,
                    color: AppColors.secondaryText,
                  ),
                ),
              ),
              SingleChildScrollView(
                child: Padding(
                  padding: EdgeInsets.only(
                    left: res.wp(5),
                    right: res.wp(5),
                    top: res.hp(40),
                  ),
                  child:  SignupForm(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
