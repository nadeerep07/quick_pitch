import 'package:flutter/material.dart';
import 'package:quick_pitch_app/core/config/responsive.dart';
import 'package:quick_pitch_app/features/poster_task/model/task_post_model.dart';
import 'package:quick_pitch_app/features/requests/poster/view/components/dialog_helper.dart' show DialogHelper;
import 'package:quick_pitch_app/features/requests/poster/view/components/fixer_avatar.dart';
import 'package:quick_pitch_app/features/requests/poster/view/screens/poster_requests_screen.dart';
import 'package:quick_pitch_app/features/task_pitching/model/pitch_model.dart';

class FixerAvatarsRow extends StatelessWidget {
  final Map<String, List<PitchModel>> fixerPitches;
  final TaskPostModel task;
  static const int maxVisibleAvatars = 4;

  const FixerAvatarsRow({
    required this.fixerPitches,
    required this.task,
  });

  @override
  Widget build(BuildContext context) {
    final res = Responsive(context);
    final fixerIds = fixerPitches.keys.toList();

    return Column(
      children: [
        SizedBox(
          height: res.wp(14),
          child: Stack(
            children: [
              ..._buildVisibleAvatars(context, fixerIds),
              if (fixerIds.length > maxVisibleAvatars)
                _buildOverflowIndicator(context, fixerIds),
            ],
          ),
        ),
        if (fixerIds.length > maxVisibleAvatars)
          _buildViewAllButton(context, fixerIds),
      ],
    );
  }

  List<Widget> _buildVisibleAvatars(BuildContext context, List<String> fixerIds) {
    final res = Responsive(context);
    
    return List.generate(
      fixerIds.length > maxVisibleAvatars ? maxVisibleAvatars : fixerIds.length,
      (i) => Positioned(
        left: i * res.wp(8),
        child: FixerAvatar(
          fixerId: fixerIds[i],
          pitch: fixerPitches[fixerIds[i]]!.first,
          task: task,
        ),
      ),
    );
  }

  Widget _buildOverflowIndicator(BuildContext context, List<String> fixerIds) {
    final res = Responsive(context);
    final colorScheme = Theme.of(context).colorScheme;
    
    return Positioned(
      left: maxVisibleAvatars * res.wp(8),
      child: GestureDetector(
        onTap: () => DialogHelper.showAllFixersDialog(
          context,
          fixerPitches: fixerPitches,
          task: task,
        ),
        child: Container(
          width: res.wp(12),
          height: res.wp(12),
          decoration: BoxDecoration(
            color: colorScheme.primaryContainer,
            shape: BoxShape.circle,
          ),
          child: Center(
            child: Text(
              '+${fixerIds.length - maxVisibleAvatars}',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: colorScheme.onPrimaryContainer,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildViewAllButton(BuildContext context, List<String> fixerIds) {
    final res = Responsive(context);
    final colorScheme = Theme.of(context).colorScheme;
    
    return Padding(
      padding: EdgeInsets.only(top: res.hp(1)),
      child: TextButton(
        onPressed: () => DialogHelper.showAllFixersDialog(
          context,
          fixerPitches: fixerPitches,
          task: task,
        ),
        child: Text(
          'View all ${fixerIds.length} fixers',
          style: TextStyle(
            fontSize: res.sp(12),
            color: colorScheme.primary,
          ),
        ),
      ),
    );
  }
}
