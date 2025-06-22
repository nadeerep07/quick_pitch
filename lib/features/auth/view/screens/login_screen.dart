import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:quick_pitch_app/features/auth/view/screens/signup_screen.dart';
import 'package:quick_pitch_app/features/auth/view/components/login_form.dart';
import 'package:quick_pitch_app/shared/config/responsive.dart';
import 'package:quick_pitch_app/shared/theme/app_colors.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final res = Responsive(context);
    return Container(
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
                    // call Google sign in in viewmodel
                  },
                  onSignupTap: () {
                    Navigator.push(context, MaterialPageRoute(
                      builder: (context) => const SignupScreen(),
                    ));
                  },
                  onLoginTap: () {
                    // call viewmodel.login()
                  },
                  onForgotTap: () {
                    // navigate to forgot password
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
