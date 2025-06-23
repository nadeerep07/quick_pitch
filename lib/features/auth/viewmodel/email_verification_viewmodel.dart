import 'dart:async';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class VerificationViewModel {
  final ValueNotifier<int> seconds = ValueNotifier<int>(60);
  final ValueNotifier<bool> canResend = ValueNotifier<bool>(false);

  late Timer _countdownTimer;
  late Timer _checkEmailVerifiedTimer;

  void startCountdown() {
    seconds.value = 60;
    canResend.value = false;

    _countdownTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (seconds.value == 0) {
        canResend.value = true;
        _countdownTimer.cancel();
      } else {
        seconds.value -= 1;
      }
    });
  }

  void startVerificationCheck(VoidCallback onVerified) {
    _checkEmailVerifiedTimer = Timer.periodic(const Duration(seconds: 3), (timer) async {
      await FirebaseAuth.instance.currentUser?.reload();
      final user = FirebaseAuth.instance.currentUser;
      if (user != null && user.emailVerified) {
        _countdownTimer.cancel();
        _checkEmailVerifiedTimer.cancel();
        onVerified();
      }
    });
  }

  Future<void> resendEmail(BuildContext context) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null && !user.emailVerified) {
      await user.sendEmailVerification();
      seconds.value = 60;
      canResend.value = false;
      startCountdown();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Verification email resent')),
      );
    }
  }

  void dispose() {
    _countdownTimer.cancel();
    _checkEmailVerifiedTimer.cancel();
    seconds.dispose();
    canResend.dispose();
  }
}