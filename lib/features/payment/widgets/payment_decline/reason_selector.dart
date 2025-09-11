import 'package:flutter/material.dart';
import 'package:quick_pitch_app/core/config/responsive.dart';

class ReasonSelector extends StatelessWidget {
  final List<String> predefinedReasons;
  final String? selectedReason;
  final Function(String?) onSelectReason;
  final Responsive res;
  final ThemeData theme;

  const ReasonSelector({
    required this.predefinedReasons,
    required this.selectedReason,
    required this.onSelectReason,
    required this.res,
    required this.theme,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Please select a reason for declining:',
          style: theme.textTheme.bodyMedium?.copyWith(
            fontWeight: FontWeight.w500,
          ),
        ),
        SizedBox(height: res.hp(1.5)),
        ConstrainedBox(
          constraints: BoxConstraints(maxHeight: res.hp(25)),
          child: SingleChildScrollView(
            child: Column(
              children: predefinedReasons.map((reason) {
                return RadioListTile<String>(
                  title: Text(reason, style: theme.textTheme.bodyMedium),
                  value: reason,
                  groupValue: selectedReason,
                  onChanged: onSelectReason,
                  contentPadding: EdgeInsets.zero,
                  visualDensity: VisualDensity.compact,
                );
              }).toList(),
            ),
          ),
        ),
      ],
    );
  }
}
