import 'package:flutter/material.dart';
import 'package:quick_pitch_app/core/config/responsive.dart';
import 'package:quick_pitch_app/features/task_pitching/model/pitch_model.dart';

class PaymentDeclineDialog extends StatefulWidget {
  final PitchModel pitch;
  final Function(String reason) onDeclinePayment;

  const PaymentDeclineDialog({
    super.key,
    required this.pitch,
    required this.onDeclinePayment,
  });

  @override
  State<PaymentDeclineDialog> createState() => PaymentDeclineDialogState();
}
class PaymentDeclineDialogState extends State<PaymentDeclineDialog> {
  final _reasonController = TextEditingController();
  String? _selectedReason;

  final List<String> _predefinedReasons = [
    'Amount is higher than agreed budget',
    'Task was not completed as specified',
    'Work quality does not meet requirements',
    'Other (specify below)',
  ];

  @override
  void dispose() {
    _reasonController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final res = Responsive(context);
    final theme = Theme.of(context);

    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: EdgeInsets.all(res.wp(5)),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(
              children: [
                Icon(Icons.cancel, color: Colors.red[500], size: res.wp(6)),
                SizedBox(width: res.wp(3)),
                Expanded(
                  child: Text(
                    'Decline Payment Request',
                    style: theme.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: res.hp(2)),

            // Reason selection
            Text(
              'Please select a reason for declining:',
              style: theme.textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w500,
              ),
            ),
            SizedBox(height: res.hp(1.5)),

            ..._predefinedReasons.map((reason) => RadioListTile<String>(
              title: Text(
                reason,
                style: theme.textTheme.bodyMedium,
              ),
              value: reason,
              groupValue: _selectedReason,
              onChanged: (value) => setState(() => _selectedReason = value),
              contentPadding: EdgeInsets.zero,
            )),

            // Additional notes field
            if (_selectedReason == 'Other (specify below)') ...[
              SizedBox(height: res.hp(1)),
              TextFormField(
                controller: _reasonController,
                maxLines: 3,
                decoration: InputDecoration(
                  hintText: 'Please specify the reason...',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ],

            SizedBox(height: res.hp(3)),

            // Action buttons
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: Text('Cancel'),
                  ),
                ),
                SizedBox(width: res.wp(3)),
                Expanded(
                  child: ElevatedButton(
                    onPressed: _selectedReason != null ? () {
                      final reason = _selectedReason == 'Other (specify below)'
                          ? _reasonController.text.trim()
                          : _selectedReason!;
                      
                      if (reason.isNotEmpty) {
                        Navigator.of(context).pop();
                        widget.onDeclinePayment(reason);
                      }
                    } : null,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red[600],
                      foregroundColor: Colors.white,
                    ),
                    child: Text('Decline'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

