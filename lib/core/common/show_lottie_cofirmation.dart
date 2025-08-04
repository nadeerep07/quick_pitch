import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:quick_pitch_app/core/config/app_colors.dart';

Future<void> showLottieConfirmation(
  BuildContext context, {
  required String message,
  required String animationPath,
  bool autoClose = true,
  Duration? closeAfter, // ⬅ custom timer
  String? buttonText,
  VoidCallback? onButtonPressed,
}) async {
  return showDialog(
    context: context,
    barrierDismissible: false,
    builder: (_) => Dialog(
      backgroundColor: Colors.transparent,
      elevation: 0,
      insetPadding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Lottie.asset(
            animationPath,
            width: 240,
            height: 240,
            repeat: false,
            fit: BoxFit.contain,
            onLoaded: (composition) {
              if (autoClose && onButtonPressed == null) {
                // Use custom timer if provided, else animation duration
                final delay = closeAfter ?? composition.duration;
                Future.delayed(delay, () {
                  if (Navigator.of(context).canPop()) {
                    Navigator.of(context).pop();
                  }
                });
              }
            },
          ),
          const SizedBox(height: 14),
          if (message.isNotEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                message,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                  color: AppColors.secondaryText,
                ),
              ),
            ),
          if (buttonText != null && onButtonPressed != null) ...[
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                onButtonPressed();
              },
              child: Text(buttonText),
            ),
          ],
        ],
      ),
    ),
  );
}
