import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:quick_pitch_app/core/routes/app_routes.dart';
import 'package:quick_pitch_app/features/auth/view/screens/login_screen.dart';
import 'package:quick_pitch_app/features/role_selection/view/select_role_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
// import 'package:quick_pitch_app/features/home/view/home_screen.dart';
import 'package:quick_pitch_app/features/onboarding/view/onboarding_screen.dart';

class SplashViewmodel {
  void startTimer(BuildContext context) async {
    await Future.delayed(const Duration(seconds: 4));

    final prefs = await SharedPreferences.getInstance();
    // await prefs.setBool('onboarding_done', false);
    final onboardingShown = prefs.getBool('onboarding_done') ?? false;
    final currentUser = FirebaseAuth.instance.currentUser;

    if (!onboardingShown) {
      Navigator.of(
        context,
      ).pushReplacement(MaterialPageRoute(builder: (_) => OnboardingScreen()));
    } else if (currentUser != null) {
      await currentUser.reload();
      final refreshedUser = FirebaseAuth.instance.currentUser;
      if (refreshedUser != null && !refreshedUser.emailVerified) {
        Navigator.pushReplacementNamed(
          context,
          AppRoutes.login,
        ); // force login again
        return;
      }
      final doc =
          await FirebaseFirestore.instance
              .collection('users')
              .doc(currentUser.uid)
              .get();

      final role = doc.data()?['activeRole'];

      if (role == 'poster') {
        Navigator.pushReplacementNamed(context, AppRoutes.posterBottomNav);
      } else if (role == 'fixer') {
        Navigator.pushReplacementNamed(context, AppRoutes.fixerBottomNav);
      } else {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (_) => const SelectRoleScreen()),
        );
      }
    } else {
      Navigator.of(context).pushReplacement(
        PageRouteBuilder(
          pageBuilder: (_, __, ___) => LoginScreen(),
          transitionsBuilder: (_, animation, __, child) {
            return FadeTransition(opacity: animation, child: child);
          },
          transitionDuration: Duration(milliseconds: 500),
        ),
      );
    }
  }
}
