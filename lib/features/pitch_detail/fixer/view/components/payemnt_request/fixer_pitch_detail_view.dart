import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quick_pitch_app/core/config/responsive.dart';
import 'package:quick_pitch_app/features/pitch_detail/fixer/viewmodel/cubit/fixer_pitch_detail_cubit.dart';
import 'package:quick_pitch_app/features/pitch_detail/fixer/widgets/fixer_pitch_detail_body.dart';

class FixerPitchDetailView extends StatelessWidget {
  const FixerPitchDetailView({super.key});

  @override
  Widget build(BuildContext context) {
    final res = Responsive(context);
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: Text('Pitch Details'),
        elevation: 0,
        backgroundColor: colorScheme.surface,
        foregroundColor: colorScheme.onSurface,
      ),
      body: BlocConsumer<FixerPitchDetailCubit, FixerPitchDetailState>(
        listener: (context, state) {
          if (state is FixerPitchDetailError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.red,
                behavior: SnackBarBehavior.floating,
              ),
            );
          }
        },
        builder: (context, state) {
          if (state is FixerPitchDetailLoading) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(),
                  SizedBox(height: res.hp(2)),
                  Text(
                    'Loading pitch details...',
                    style: theme.textTheme.bodyLarge?.copyWith(
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            );
          }

          if (state is FixerPitchDetailError) {
            return Center(
              child: Padding(
                padding: EdgeInsets.all(res.wp(5)),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.error_outline, size: res.wp(12), color: Colors.red),
                    SizedBox(height: res.hp(2)),
                    Text(
                      'Error loading pitch details',
                      style: theme.textTheme.headlineSmall,
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: res.hp(1)),
                    Text(
                      state.message,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: Colors.grey[600],
                      ),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: res.hp(3)),
                    ElevatedButton.icon(
                      onPressed: () => Navigator.of(context).pop(),
                      icon: Icon(Icons.arrow_back),
                      label: Text('Go Back'),
                      style: ElevatedButton.styleFrom(
                        padding: EdgeInsets.symmetric(
                          horizontal: res.wp(6),
                          vertical: res.hp(1.5),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          }

          if (state is FixerPitchDetailLoaded || state is FixerPitchDetailProcessing) {
            final currentPitch = state is FixerPitchDetailLoaded 
                ? state.pitch 
                : (state as FixerPitchDetailProcessing).pitch;
            final currentTask = state is FixerPitchDetailLoaded 
                ? state.task 
                : (state as FixerPitchDetailProcessing).task;

            final isAssigned = currentPitch.status == 'assigned';
            final isCompleted = currentPitch.status == 'completed';
            final isRejected = currentPitch.status == 'rejected';

            return buildPitchDetailBody(
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
            );
          }

          return Center(
            child: Text(
              'Unknown state',
              style: theme.textTheme.bodyLarge?.copyWith(
                color: Colors.grey[600],
              ),
            ),
          );
        },
      ),
    );
  }
}