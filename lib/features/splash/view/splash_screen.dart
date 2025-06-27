import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:quick_pitch_app/features/splash/viewmodel/splash_viewmodel.dart';
import 'package:quick_pitch_app/features/splash/view/components/animated_logo.dart';
import 'package:quick_pitch_app/core/config/app_colors.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final SplashViewmodel viewmodel = SplashViewmodel();
  
  @override
  void initState() {
    super.initState();
    viewmodel.startTimer(context);
  }

  @override
  Widget build(BuildContext context) {
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
