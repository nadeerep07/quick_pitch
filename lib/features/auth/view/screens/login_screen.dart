import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:quick_pitch_app/features/auth/view/components/login_form.dart';
import 'package:quick_pitch_app/features/auth/view/screens/email_verifcation.dart';
import 'package:quick_pitch_app/features/auth/view/screens/forget_password_screen.dart';
import 'package:quick_pitch_app/features/auth/view/screens/signup_screen.dart';
import 'package:quick_pitch_app/features/auth/viewmodel/bloc/auth_bloc.dart';
import 'package:quick_pitch_app/features/role_selection/view/select_role_screen.dart';
import 'package:quick_pitch_app/shared/config/responsive.dart';
import 'package:quick_pitch_app/shared/theme/app_colors.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final res = Responsive(context);

    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is AuthSuccess) {
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (_) => const SelectRoleScreen()),
            (route) => false,
          );
        } else if (state is AuthFailure) {
          // print(state.error.toString());
        } else if (state is UnverifiedEmail) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (_) => VerificationScreen(email: state.email),
            ),
          );
        }
      },
      child: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/login.png'),
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
                  'Welcome\nBack',
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
                    top: res.hp(46),
                  ),
                  child: LoginForm(
                    onGoogleTap: () {},
                    onSignupTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const SignupScreen()),
                      );
                    },
                    onForgotTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const ForgotPasswordScreen(),
                        ),
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
