import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quick_pitch_app/core/config/responsive.dart';
import 'package:quick_pitch_app/features/pitch_detail/fixer/widgets/fixer_pitch_detail_appbar.dart';
import 'package:quick_pitch_app/features/pitch_detail/fixer/widgets/fixer_pitch_detail_body.dart';
import 'package:quick_pitch_app/features/pitch_detail/fixer/widgets/fixer_pitch_detail_status_options.dart';
import 'package:quick_pitch_app/features/poster_task/model/task_post_model.dart';
import 'package:quick_pitch_app/features/task_pitching/model/pitch_model.dart';
import 'package:quick_pitch_app/features/pitch_detail/fixer/viewmodel/cubit/fixer_pitch_detail_cubit.dart';


class FixerPitchDetailUIHelper {
  final BuildContext context;
  final Responsive res;
  final FixerPitchDetailState state;
  final PitchModel initialPitch;

  FixerPitchDetailUIHelper({
    required this.context,
    required this.res,
    required this.state,
    required this.initialPitch,
  });

  ThemeData get theme => Theme.of(context);
  ColorScheme get colorScheme => theme.colorScheme;
  PitchModel get currentPitch => _extractPitch(state);
  TaskPostModel? get currentTask => _extractTask(state);

  bool get isRejected => currentPitch.status.toLowerCase() == 'rejected';
  bool get isAssigned => currentPitch.status.toLowerCase() == 'accepted';
  bool get isCompleted => currentPitch.status.toLowerCase() == 'completed';

  AppBar buildAppBar() =>
      buildPitchAppBar(context, colorScheme, theme, isAssigned, isCompleted);

  Widget buildDetailBody() => buildPitchDetailBody(
        context: context,
        res: res,
        state: state,
        currentPitch: currentPitch,
        currentTask: currentTask,
        colorScheme: colorScheme,
        theme: theme,
        isAssigned: isAssigned,
        isCompleted: isCompleted,
        isRejected: isRejected,
        onRequestPayment: _requestPayment,
      );

  void _requestPayment() async {
    final confirmed =
        await showRequestPaymentDialog(context, res, currentPitch);
    if (confirmed == true) {
      context.read<FixerPitchDetailCubit>().requestPayment(currentPitch.id);
    }
  }

  PitchModel _extractPitch(FixerPitchDetailState state) {
    if (state is FixerPitchDetailLoaded) return state.pitch;
    if (state is FixerPitchDetailProcessing) return state.pitch;
    return initialPitch;
  }

  TaskPostModel? _extractTask(FixerPitchDetailState state) {
    if (state is FixerPitchDetailLoaded) return state.task;
    if (state is FixerPitchDetailProcessing) return state.task;
    return null;
  }
}
