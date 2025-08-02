import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

Future<void> showLottieConfirmation(
  BuildContext context, {
  required String message,
  required String animationPath,
  bool autoClose = true,
}) {
  return showDialog(
    context: context,
    barrierDismissible: false,
    builder: (_) => Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Lottie.asset(
              animationPath,
              width: 150,
              repeat: false,
              onLoaded: (composition) {
                if (autoClose) {
                  Future.delayed(composition.duration, () {
                    Navigator.of(context).pop();
                  });
                }
              },
            ),
            const SizedBox(height: 16),
            Text(
              message,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    ),
  );
}
