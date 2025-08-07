import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quick_pitch_app/core/common/main_background_painter.dart';
import 'package:quick_pitch_app/core/config/responsive.dart';
import 'package:quick_pitch_app/features/pitch_detail/fixer/view/components/fixer_pitch_detail_ui_helper.dart';
import 'package:quick_pitch_app/features/pitch_detail/fixer/viewmodel/cubit/fixer_pitch_detail_cubit.dart';
import 'package:quick_pitch_app/features/task_pitching/model/pitch_model.dart';

class FixerPitchDetailScreen extends StatelessWidget {
  final PitchModel pitch;
  final Responsive res;

  const FixerPitchDetailScreen({
    super.key,
    required this.pitch,
    required this.res,
  });

  @override
  Widget build(BuildContext context) {

  

    return BlocConsumer<FixerPitchDetailCubit, FixerPitchDetailState>(
      listener: (context, state) {
        if (state is FixerPitchDetailError) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(state.message)));
        }
      },
      builder: (context, state) {
        final uiHelper = FixerPitchDetailUIHelper(
          context: context,
          res: res,
          initialPitch: pitch,
          state: state,
        );

        return Scaffold(
          appBar: uiHelper.buildAppBar(),
          extendBodyBehindAppBar: true,
          body: Stack(
            children: [
              CustomPaint(
                painter: MainBackgroundPainter(),
                size: Size.infinite,
              ),
              if (state is FixerPitchDetailLoading)
                const Center(child: CircularProgressIndicator()),
              if (state is FixerPitchDetailError)
                const Center(child: Text('Failed to load task details')),
              if (state is FixerPitchDetailLoaded ||
                  state is FixerPitchDetailProcessing ||
                  state is FixerPitchDetailInitial)
                uiHelper.buildDetailBody(),
            ],
          ),
        );
      },
    );
  }
}
