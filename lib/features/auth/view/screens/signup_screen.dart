import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:quick_pitch_app/features/auth/view/components/signup_form.dart';
import 'package:quick_pitch_app/shared/config/responsive.dart';
import 'package:quick_pitch_app/shared/theme/app_colors.dart';

class SignupScreen extends StatelessWidget {
  const SignupScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final res = Responsive(context);
    return Container(
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
                  top: res.hp(46),
                ),
                child: const SignupForm(), 
              ),
            ),
          ],
        ),
      ),
    );
  }
}
