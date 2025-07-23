import 'package:flutter/material.dart';
import 'package:quick_pitch_app/core/config/app_colors.dart';
import 'package:quick_pitch_app/core/config/responsive.dart';

class SendPitchButton extends StatelessWidget {
  final Responsive res;

  const SendPitchButton({super.key, required this.res});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(res.wp(5)),
      child: SizedBox(
        width: double.infinity,
        height: res.hp(6),
        child: ElevatedButton(
          onPressed: () {},
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primaryColor,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          child: Text(
            "Send Pitch",
            style: TextStyle(
              color: Colors.white,
              fontSize: res.sp(14),
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }
}
