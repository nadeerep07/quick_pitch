import 'package:flutter/material.dart';
import 'package:quick_pitch_app/core/config/responsive.dart';

class PaymentBuildActions extends StatelessWidget {
  final Responsive res;
  final bool isProcessing;
  final VoidCallback onCancel;
  final VoidCallback onConfirm;
  final bool isFromRequest;

  const PaymentBuildActions({
    super.key,
    required this.res,
    required this.isProcessing,
    required this.onCancel,
    required this.onConfirm,
    required this.isFromRequest,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: OutlinedButton(
            onPressed: isProcessing ? null : onCancel,
            style: OutlinedButton.styleFrom(
              padding: EdgeInsets.symmetric(vertical: res.hp(1.5)),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: const Text('Cancel'),
          ),
        ),
        SizedBox(width: res.wp(3)),
        Expanded(
          child: ElevatedButton(
            onPressed: isProcessing ? null : onConfirm,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green[600],
              foregroundColor: Colors.white,
              padding: EdgeInsets.symmetric(vertical: res.hp(1.5)),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: isProcessing
                ? SizedBox(
                    height: res.hp(2),
                    width: res.hp(2),
                    child: const CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    ),
                  )
                : Text(isFromRequest ? 'Approve & Pay' : 'Pay Now'),
          ),
        ),
      ],
    );
  }
}