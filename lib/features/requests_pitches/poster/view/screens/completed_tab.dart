import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quick_pitch_app/features/pitch_detail/poster/view/screen/pitch_complete_detail_screen.dart';
import 'package:quick_pitch_app/features/requests_pitches/poster/view/components/completed_tab_sections/completed_task_card.dart';
import 'package:quick_pitch_app/features/requests_pitches/poster/view/components/completed_tab_sections/empty_state.dart';
import 'package:quick_pitch_app/features/requests_pitches/poster/view/components/completed_tab_sections/error_state.dart';
import 'package:quick_pitch_app/features/requests_pitches/poster/view/components/completed_tab_sections/loading_state.dart';
import 'package:quick_pitch_app/features/requests_pitches/poster/viewmodel/cubit/pitches_state.dart';
import 'package:quick_pitch_app/features/task_pitching/model/pitch_model.dart';
import 'package:quick_pitch_app/features/poster_task/model/task_post_model.dart';

class CompletedTab extends StatelessWidget {
  const CompletedTab({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PitchesCubit, PitchesState>(
      builder: (context, state) {
        if (state is PitchesLoading) return const LoadingState();
        if (state is PitchesError) return ErrorState(message: state.message);
        if (state is PitchesLoaded) {
          if (state.completed.isEmpty) return const EmptyState();

          return RefreshIndicator(
            onRefresh:
                () async => context.read<PitchesCubit>().listenToPitches(),
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: state.completed.length,
              itemBuilder: (context, index) {
                final item = state.completed[index];
                final task = item['task'] as TaskPostModel;
                final pitches = item['pitches'] as List<PitchModel>;

                return GestureDetector(
                  onTap: () {
                    if (pitches.isNotEmpty) {
                      final pitchId = pitches.first.id;
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder:
                              (_) => PitchCompleteDetailScreen(
                                task: task,
                                pitchId: pitchId,
                              ),
                        ),
                      );
                    }
                  },
                  child: CompletedTaskCard(task: task, pitches: pitches),
                );
              },
            ),
          );
        }

        return const EmptyState();
      },
    );
  }
}
