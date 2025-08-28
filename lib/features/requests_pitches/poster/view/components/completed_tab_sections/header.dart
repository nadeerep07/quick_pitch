import 'package:flutter/material.dart';
import 'package:quick_pitch_app/core/common/date_formatter.dart';
import 'package:quick_pitch_app/features/task_pitching/model/pitch_model.dart';

/// --------------------
///  Sub-widgets for Card
/// --------------------
class Header extends StatelessWidget {
  final PitchModel acceptedPitch;
  const Header({required this.acceptedPitch});

  @override
  Widget build(BuildContext context) => Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _statusBadge(),
          if (acceptedPitch.completionDate != null) _completionDate(),
        ],
      );

  Widget _statusBadge() => Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: Colors.green.shade50,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.green.shade200, width: 1),
        ),
        child: Row(mainAxisSize: MainAxisSize.min, children: [
          Container(width: 6, height: 6, decoration: const BoxDecoration(color: Colors.green, shape: BoxShape.circle)),
          const SizedBox(width: 6),
          Text('Completed',
              style: TextStyle(
                  color: Colors.green.shade700,
                  fontSize: 12,
                  fontWeight: FontWeight.w600)),
        ]),
      );

  Widget _completionDate() => Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
        decoration: BoxDecoration(
            color: Colors.grey.shade50,
            borderRadius: BorderRadius.circular(12)),
        child: Text(
          DateFormatter.format(acceptedPitch.completionDate!),
          style: TextStyle(
              color: Colors.grey.shade600,
              fontSize: 12,
              fontWeight: FontWeight.w500),
        ),
      );
}
