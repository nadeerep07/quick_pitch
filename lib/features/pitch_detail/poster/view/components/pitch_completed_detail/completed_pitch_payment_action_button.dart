import 'package:flutter/material.dart';
import 'package:quick_pitch_app/core/common/app_button.dart';

class CompletedPitchPaymentActionButton extends StatelessWidget {
  const CompletedPitchPaymentActionButton({
    super.key,
  });

@override
  Widget build(BuildContext context) {
  return  AppButton(onPressed: (){}, text:'Pay Now',);
  }
  
}