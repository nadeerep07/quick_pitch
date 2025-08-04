import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quick_pitch_app/features/requests/poster/view/components/placeholder_content.dart';
import 'package:quick_pitch_app/features/requests/poster/viewmodel/cubit/pitches_state.dart';
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
              return Card(
                margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                child: ListTile(
                  title: Text(task.title),
                  subtitle: Text(task.description),
                  trailing: Text(
                    task.status.toUpperCase(),
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.green,
                    ),
                  ),
                ),
              );
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
