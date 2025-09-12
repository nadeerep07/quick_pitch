import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quick_pitch_app/core/common/main_background_painter.dart';
import 'package:quick_pitch_app/core/config/responsive.dart';
import 'package:quick_pitch_app/features/payment/viewmodel/cubit/payment_cubit.dart';
import 'package:quick_pitch_app/features/pitch_detail/poster/view/widget/complete_body.dart';
import 'package:quick_pitch_app/features/pitch_detail/poster/view/widget/processing_overlay.dart';
import 'package:quick_pitch_app/features/poster_task/model/task_post_model.dart';



// Main Screen
class PitchCompleteDetailScreen extends StatelessWidget {
  final TaskPostModel task;
  final String? pitchId;

  const PitchCompleteDetailScreen({
    super.key,
    required this.task,
    required this.pitchId,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final res = Responsive(context);

    return BlocProvider(
      create: (_) => PaymentCubit(),
      child: BlocBuilder<PaymentCubit, PaymentState>(
        builder: (context, paymentState) {
          return Scaffold(
            appBar: AppBar(
              title: const Text('Completed Details'),
              centerTitle: true,
              elevation: 0,
              backgroundColor: Colors.transparent,
              foregroundColor: theme.colorScheme.onSurface,
            ),
            body: Stack(
              children: [
                CustomPaint(
                  painter: MainBackgroundPainter(),
                  size: Size.infinite,
                ),
                CompleteBody(
                  task: task,
                  pitchId: pitchId,
                  res: res,
                  theme: theme,
                ),
                if (paymentState.isProcessing)
                  ProcessingOverlay(res: res, theme: theme),
              ],
            ),
          );
        },
      ),
    );
  }
}
