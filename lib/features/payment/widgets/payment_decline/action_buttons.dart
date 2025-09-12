import 'package:flutter/material.dart';
import 'package:quick_pitch_app/core/config/responsive.dart';

class ActionButtons extends StatelessWidget {
  final String? selectedReason;
  final TextEditingController reasonController;
  final Function(String reason) onDeclinePayment;
  final Responsive res;

  const ActionButtons({super.key, 
    required this.selectedReason,
    required this.reasonController,
    required this.onDeclinePayment,
    required this.res,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: OutlinedButton(
            onPressed: () => Navigator.of(context).pop(),
            style: OutlinedButton.styleFrom(
              padding: EdgeInsets.symmetric(vertical: res.hp(1.5)),
            ),
            child: const Text('Cancel'),
          ),
        ),
        SizedBox(width: res.wp(3)),
        Expanded(
          child: ElevatedButton(
            onPressed: selectedReason != null
                ? () {
                    final reason = selectedReason == 'Other (specify below)'
                        ? reasonController.text.trim()
                        : selectedReason!;

                    if (reason.isNotEmpty) {
                      Navigator.of(context).pop();
                      onDeclinePayment(reason);
                    }
                  }
                : null,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red[600],
              foregroundColor: Colors.white,
              padding: EdgeInsets.symmetric(vertical: res.hp(1.5)),
            ),
            child: const Text('Decline Payment'),
          ),
        ),
      ],
    );
  }
}
