import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quick_pitch_app/features/requests_pitches/poster/view/components/asiggned_tab_sections/assigned_task_card.dart';
import 'package:quick_pitch_app/features/requests_pitches/poster/view/components/pitch_tab_section/placeholder_content.dart';
import 'package:quick_pitch_app/features/requests_pitches/poster/viewmodel/cubit/pitches_state.dart';
import 'package:quick_pitch_app/features/poster_task/model/task_post_model.dart';

class AssignedTab extends StatelessWidget {
  const AssignedTab({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PitchesCubit, PitchesState>(
      builder: (context, state) {
        if (state is PitchesLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        if (state is PitchesLoaded) {
          final assigned = state.assigned;

          if (assigned.isEmpty) {
            return const PlaceholderContent(
              message: "No tasks have been assigned yet.",
            );
          }

          return ListView.builder(
            itemCount: assigned.length,
            itemBuilder: (context, index) {
              final task = assigned[index]['task'] as TaskPostModel;
              final pitches = assigned[index]['pitches'] as List;

              return AssignedTaskCard(task: task, pitches: pitches);
            },
          );
        }

        if (state is PitchesError) {
          return Center(child: Text(state.message));
        }

        return const SizedBox.shrink();
      },
    );
  }
}
