import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:quick_pitch_app/features/role_selection/view/select_role_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:quick_pitch_app/features/auth/view/screens/login_screen.dart';
// import 'package:quick_pitch_app/features/home/view/home_screen.dart';
import 'package:quick_pitch_app/features/onboarding/view/onboarding_screen.dart';

class SplashViewmodel {
  void startTimer(BuildContext context) {
    Timer(const Duration(seconds: 3), () async {
      final prefs = await SharedPreferences.getInstance();
      final onboardingShown = prefs.getBool('onboarding_done') ?? false;
      final currentUser = FirebaseAuth.instance.currentUser;

      if (!onboardingShown) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (_) => OnboardingScreen()),
        );
        } else if (currentUser != null) {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (_) => const SelectRoleScreen()),
          );
      } else {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (_) => const LoginScreen()),
        );
      }
    });
  }
}
