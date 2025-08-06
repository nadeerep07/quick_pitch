import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quick_pitch_app/core/config/responsive.dart';
import 'package:quick_pitch_app/features/pitch_detail/fixer/view/components/fixer_pitch_detail_item.dart';
import 'package:quick_pitch_app/features/pitch_detail/fixer/viewmodel/cubit/fixer_pitch_detail_cubit.dart';
import 'package:quick_pitch_app/features/task_pitching/model/pitch_model.dart';

class FixerPitchDetailProgressSection extends StatelessWidget {
  const FixerPitchDetailProgressSection({
    super.key,
    required this.res,
    required this.context,
    required this.theme,
    required this.colorScheme,
    required this.currentPitch,
  });

  final Responsive res;
  final BuildContext context;
  final ThemeData theme;
  final ColorScheme colorScheme;
  final PitchModel currentPitch;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(
          color: colorScheme.outline.withValues(alpha: 0.2),
          width: 1,
        ),
      ),
      child: Padding(
        padding: EdgeInsets.all(res.wp(4)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'WORK PROGRESS',
              style: theme.textTheme.labelSmall?.copyWith(
                color: colorScheme.onSurface.withValues(alpha: 0.6),
                letterSpacing: 1,
              ),
            ),
            SizedBox(height: res.hp(2)),
            
            // Progress Slider
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Completion: ${currentPitch.progress?.toStringAsFixed(0) ?? '0'}%',
                  style: theme.textTheme.bodyMedium,
                ),
                SizedBox(height: res.hp(1)),
                Slider(
                  value: currentPitch.progress?.toDouble() ?? 0,
                  min: 0,
                  max: 100,
                  divisions: 10,
                  label: '${currentPitch.progress?.toStringAsFixed(0) ?? '0'}%',
                  onChanged: (value) {
                    context.read<FixerPitchDetailCubit>().updateProgress(currentPitch.id, value.toInt());
                  },
                ),
              ],
            ),
            SizedBox(height: res.hp(2)),
            
            // Updates/Comments
            FixerPitchDetailItem(res: res, icon: Icons.comment, label: 'Latest Update', value: currentPitch.latestUpdate ?? 'No updates yet', theme: theme, colorScheme: colorScheme),
          ],
        ),
      ),
    );
  }
}
