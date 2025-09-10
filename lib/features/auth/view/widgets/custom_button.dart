import 'package:flutter/material.dart';
import 'package:quick_pitch_app/core/config/app_colors.dart';

class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final bool isLoading;
  final Color? backgroundColor;
  final Color? textColor;
  final double height;

  const CustomButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.isLoading = false,
    this.backgroundColor,
    this.textColor,
    this.height = 48, 
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      child: DecoratedBox(
         decoration: BoxDecoration(
          gradient: AppColors.primaryGradient, 
          borderRadius: BorderRadius.circular( 10),
        ),
        child: ElevatedButton(
          onPressed: isLoading ? null : onPressed,
          style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent, 
            shadowColor: Colors.transparent,
            minimumSize: Size(double.infinity, height),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          child: isLoading
              ? const SizedBox(
                  height: 20,
                  width: 20,
                  child: CircularProgressIndicator(
                    color: AppColors.primaryText,
                    strokeWidth: 2,
                  ),
                )
              : Text(
                  text,
                  style: const TextStyle(fontWeight: FontWeight.w600),
                ),
        ),
      ),
    );
  }
}
