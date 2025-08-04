import 'package:flutter/material.dart';
import 'package:quick_pitch_app/core/config/responsive.dart';
import 'package:quick_pitch_app/features/requests/fixer/view/components/pitch_card.dart';
import 'package:quick_pitch_app/features/task_pitching/model/pitch_model.dart';

class PitchesList extends StatelessWidget {
  final List<PitchModel> pitches;
  final Responsive res;
  final ThemeData theme;

  const PitchesList({
    super.key,
    required this.pitches,
    required this.res,
    required this.theme,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: EdgeInsets.fromLTRB(res.wp(4), 0, res.wp(4), res.wp(4)),
      itemCount: pitches.length,
      separatorBuilder: (_, __) => SizedBox(height: res.wp(3)),
      itemBuilder: (context, index) {
        return PitchCard(pitch: pitches[index], res: res, theme: theme);
      },
    );
  }
}
