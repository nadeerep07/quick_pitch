import 'package:flutter/material.dart';
import 'package:quick_pitch_app/core/config/app_colors.dart';

class AppButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final double? width;
  final double? height;
  final double? borderRadius;
  final bool isLoading;

  const AppButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.width,
    this.height,
    this.borderRadius,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width ?? double.infinity,
      height: height ?? 48,
      child: DecoratedBox(
        decoration: BoxDecoration(
          gradient: AppColors.primaryGradient, // 👈 use gradient here
          borderRadius: BorderRadius.circular(borderRadius ?? 10),
        ),
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.transparent, // 👈 transparent bg
            shadowColor: Colors.transparent, // 👈 remove shadow
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(borderRadius ?? 10),
            ),
          ),
          onPressed: isLoading ? null : onPressed,
          child: isLoading
              ? const SizedBox(
                  width: 22,
                  height: 22,
                  child: CircularProgressIndicator(
                    color: Colors.white,
                    strokeWidth: 2.5,
                  ),
                )
              : Text(
                  text,
                  style: const TextStyle(fontSize: 16, color: Colors.white),
                ),
        ),
      ),
    );
  }
}
