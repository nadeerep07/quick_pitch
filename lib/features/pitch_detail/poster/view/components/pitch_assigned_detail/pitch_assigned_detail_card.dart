import 'package:flutter/material.dart';
import 'package:quick_pitch_app/core/config/app_colors.dart';
import 'package:quick_pitch_app/core/utils/status_color_util.dart';
import 'package:quick_pitch_app/features/pitch_detail/poster/view/components/pitch_assigned_detail/pitch_assigned_progress_section.dart';
import 'package:quick_pitch_app/features/pitch_detail/poster/view/components/pitch_assigned_detail/poster_a_ssigned_fixer_detail_row.dart';
import 'package:quick_pitch_app/features/poster_task/model/task_post_model.dart';
import 'package:quick_pitch_app/features/task_pitching/model/pitch_model.dart';


class PitchDetailCard extends StatelessWidget {
  final TaskPostModel task;
  final PitchModel pitch;

  const PitchDetailCard({
    super.key,
    required this.task,
    required this.pitch,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final statusColor = StatusColorUtil.getStatusColor(task.status, theme);

    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Title + Status
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    "Pitch for: ${task.title}",
                    style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Chip(
                  backgroundColor: statusColor,
                  label: Text(
                    pitch.status.toUpperCase(),
                    style: theme.textTheme.labelMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: AppColors.icon1,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            PosterASsignedFixerDetailRow(
              context: context,
              icon: Icons.description,
              label: "Pitch Text:",
              value: pitch.pitchText,
            ),
            const SizedBox(height: 12),

            Row(
              children: [
                Expanded(
                  child: PosterASsignedFixerDetailRow(
                    context: context,
                    icon: Icons.attach_money,
                    label: "Budget:",
                    value: "₹${pitch.budget}",
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: PosterASsignedFixerDetailRow(
                    context: context,
                    icon: Icons.schedule,
                    label: "Timeline:",
                    value: pitch.timeline,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),

            if (pitch.hours != null)
              PosterASsignedFixerDetailRow(
                context: context,
                icon: Icons.access_time,
                label: "Hours:",
                value: pitch.hours.toString(),
              ),
            const SizedBox(height: 12),

            PosterASsignedFixerDetailRow(
              context: context,
              icon: Icons.payment,
              label: "Payment Type:",
              value: pitch.paymentType.name,
            ),
            const SizedBox(height: 16),

            Divider(color: theme.colorScheme.outlineVariant),
            const SizedBox(height: 8),

            PitchProgressSection(pitch: pitch),
            if (pitch.latestUpdate != null) ...[
              const SizedBox(height: 12),
              PosterASsignedFixerDetailRow(
                context: context,
                icon: Icons.update,
                label: "Latest Update:",
                value: pitch.latestUpdate!,
              ),
            ],
          ],
        ),
      ),
    );
  }
}
