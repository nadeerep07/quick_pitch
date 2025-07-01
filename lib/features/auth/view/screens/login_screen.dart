import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:quick_pitch_app/core/routes/app_routes.dart';
import 'package:quick_pitch_app/features/auth/view/components/login_form.dart';
import 'package:quick_pitch_app/features/auth/view/screens/email_verifcation.dart';
import 'package:quick_pitch_app/features/auth/view/screens/forget_password_screen.dart';
import 'package:quick_pitch_app/features/auth/viewmodel/bloc/auth_bloc.dart';
import 'package:quick_pitch_app/features/main/poster/view/nav_bar/poster_bottom_nav.dart';
import 'package:quick_pitch_app/features/role_selection/view/select_role_screen.dart';
import 'package:quick_pitch_app/core/config/responsive.dart';
import 'package:quick_pitch_app/core/config/app_colors.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final res = Responsive(context);

    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is AuthRoleIdentified) {
          final role = state.role;
          if (role == 'poster') {
            Navigator.pushReplacementNamed(context, AppRoutes.posterBottomNav);
          } else if (role == 'fixer') {
            Navigator.pushReplacementNamed(context, AppRoutes.fixerBottomNav);
          }
        } else if (state is AuthSuccess) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (_) => const SelectRoleScreen()),
          );
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
                    onGoogleTap: () {
                      context.read<AuthBloc>().add(GoogleSignInRequested());
                    },
                    onSignupTap: () {
                      Navigator.pushNamed(context, AppRoutes.signup);
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
