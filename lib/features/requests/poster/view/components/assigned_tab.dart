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
                elevation: 3,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(
                              task.title,
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color:  Colors.orange,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              task.status.toUpperCase(),
                              style: const TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(
                        task.description,
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey[700],
                        ),
                      ),
                      const SizedBox(height: 12),
                      ...[
                      _buildDetailRow(
                        Icons.calendar_today,
                        'Due Date: ${task.deadline.toLocal().toString().split(' ')[0]}',
                      ),
                      const SizedBox(height: 8),
                    ],
                      ...[
                      _buildDetailRow(
                        Icons.priority_high,
                        'Priority: ${task.priority}',
                      ),
                      const SizedBox(height: 8),
                    ],
                      if (task.assignedFixerName != null) ...[
                        _buildDetailRow(
                          Icons.person,
                          'Assigned to: ${task.assignedFixerName}',
                        ),
                      ],
                    ],
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

  Widget _buildDetailRow(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, size: 16, color: Colors.grey[600]),
        const SizedBox(width: 8),
        Text(
          text,
          style: TextStyle(
            fontSize: 13,
            color: Colors.grey[800],
          ),
        ),
      ],
    );
  }
}