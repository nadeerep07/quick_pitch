import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quick_pitch_app/core/common/date_formatter.dart';
import 'package:quick_pitch_app/core/config/app_colors.dart';
import 'package:quick_pitch_app/features/pitch_detail/poster/view/screen/pitch_assigned_detail_screen.dart';
import 'package:quick_pitch_app/features/profile_completion/model/user_profile_model.dart';
import 'package:quick_pitch_app/features/requests_pitches/poster/view/components/asiggned_tab_sections/assigned_fixer_section.dart';
import 'package:quick_pitch_app/features/requests_pitches/poster/view/components/asiggned_tab_sections/assigned_task_card.dart';
import 'package:quick_pitch_app/features/requests_pitches/poster/view/components/asiggned_tab_sections/task_description.dart';
import 'package:quick_pitch_app/features/requests_pitches/poster/view/components/asiggned_tab_sections/task_details_section.dart';
import 'package:quick_pitch_app/features/requests_pitches/poster/view/components/asiggned_tab_sections/task_header.dart';
import 'package:quick_pitch_app/features/requests_pitches/poster/view/components/asiggned_tab_sections/task_status_section.dart';
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
