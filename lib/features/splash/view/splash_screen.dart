import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:quick_pitch_app/features/splash/viewmodel/splash_viewmodel.dart';
import 'package:quick_pitch_app/features/splash/view/components/animated_logo.dart';
import 'package:quick_pitch_app/shared/theme/app_colors.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // WidgetsBinding.instance.addPostFrameCallback((_) {
    SplashViewmodel().startTimer(context);
    // });

    return Scaffold(
      backgroundColor: AppColors.primaryBackground,
      body: Stack(
        children: [
          SizedBox.expand(
            child: Lottie.asset(
              'assets/animations/splash_animi.json',
              fit: BoxFit.cover,
              repeat: false,
            ),
          ),

          const Center(child: AnimatedLogo()),
        ],
      ),
    );
  }
}
