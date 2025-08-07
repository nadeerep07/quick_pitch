import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quick_pitch_app/core/config/responsive.dart';
import 'package:quick_pitch_app/core/services/pitch/pitch_status_services.dart';
import 'package:quick_pitch_app/core/services/pitch/pitch_update_services.dart';
import 'package:quick_pitch_app/features/pitch_detail/fixer/view/screens/fixer_pitch_detail_screen.dart';
import 'package:quick_pitch_app/features/pitch_detail/fixer/viewmodel/cubit/fixer_pitch_detail_cubit.dart';
import 'package:quick_pitch_app/features/poster_task/repository/task_post_repository.dart';
import 'package:quick_pitch_app/features/requests/fixer/view/components/pitch_card.dart';
import 'package:quick_pitch_app/features/task_pitching/model/pitch_model.dart';
import 'package:quick_pitch_app/features/task_pitching/repository/pitch_repository.dart';

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
        return GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder:
                    (_) => BlocProvider(
                      create:
                          (context) => FixerPitchDetailCubit(
                            pitchStatusService: PitchStatusService(),
                            pitchUpdateService: PitchUpdateService(),
                            taskRepository: TaskPostRepository(),
                            pitchRepository: PitchRepository(),
                          ),
                      child: FixerPitchDetailScreen(
                        pitch: pitches[index],
                        res: res,
                      ),
                    ),
              ),
            );
          },
          child: PitchCard(pitch: pitches[index], res: res, theme: theme),
        );
      },
    );
  }
}
