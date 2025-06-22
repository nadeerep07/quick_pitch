import 'dart:async';

import 'package:flutter/material.dart';
import 'package:quick_pitch_app/features/onboarding/view/onboarding_screen.dart';

class SplashViewmodel {
  void startTimer(BuildContext context){
    Timer(const Duration(seconds: 3),(){
    Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (_)=>  OnboardingScreen()));
    });
  }
}