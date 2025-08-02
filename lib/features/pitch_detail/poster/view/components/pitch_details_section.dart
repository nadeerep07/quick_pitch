import 'package:flutter/material.dart';
import 'package:quick_pitch_app/core/config/responsive.dart';
import 'package:quick_pitch_app/features/pitch_detail/poster/view/components/detail_row.dart';
import 'package:quick_pitch_app/features/pitch_detail/poster/view/screen/pitch_detail_screen.dart';
import 'package:quick_pitch_app/features/task_pitching/model/pitch_model.dart';

/// Pitch Details Section
class PitchDetailsSection extends StatelessWidget {
  final PitchModel pitch;
  const PitchDetailsSection({super.key, required this.pitch});

  @override
  Widget build(BuildContext context) {
    final res = Responsive(context);
    final colorScheme = Theme.of(context).colorScheme;

    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(res.wp(4)),
      ),
      color: colorScheme.surface.withOpacity(0.9),
      child: Padding(
        padding: EdgeInsets.all(res.wp(4)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Pitch Details',
              style: TextStyle(
                fontSize: res.sp(16),
                fontWeight: FontWeight.bold,
                color: colorScheme.primary,
              ),
            ),
            SizedBox(height: res.hp(1.5)),
            DetailRow(
              icon: Icons.message,
              label: 'Pitch',
              value: pitch.pitchText,
              isMultiLine: true,
            ),
            DetailRow(
              icon: Icons.payment,
              label: 'Payment Type',
              value: pitch.paymentType.name,
            ),
            DetailRow(
              icon: Icons.payments,
              label: 'Proposed Budget',
              value: '₹${pitch.budget}',
            ),
            if (pitch.paymentType.name == 'hourly')
              DetailRow(
                icon: Icons.view_timeline,
                label: 'Time Takes',
                value: pitch.hours!,
              ),
            if (pitch.paymentType.name == 'fixed')
              DetailRow(
                icon: Icons.schedule,
                label: 'Timeline',
                value: pitch.timeline,
              ),
            if (pitch.paymentType.name == 'hourly')
              DetailRow(
                icon: Icons.currency_rupee_sharp,
                label: 'Total Amount',
                value: (pitch.budget *
                        (double.tryParse(pitch.hours ?? '0') ?? 0))
                    .toString(),
              ),
          ],
        ),
      ),
    );
  }
}
