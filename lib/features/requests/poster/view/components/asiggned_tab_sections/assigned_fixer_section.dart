import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quick_pitch_app/features/poster_task/model/task_post_model.dart';
import 'package:quick_pitch_app/features/profile_completion/model/user_profile_model.dart';
import 'package:quick_pitch_app/features/requests/poster/view/components/asiggned_tab_sections/task_details_section.dart';
import 'package:quick_pitch_app/features/requests/poster/view/components/asiggned_tab_sections/task_status_section.dart';
import 'package:quick_pitch_app/features/requests/poster/viewmodel/cubit/pitches_state.dart';

class AssignedFixerSection extends StatelessWidget {
  final TaskPostModel task;

  const AssignedFixerSection({super.key, required this.task});

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
      child: ExpansionTile(
        tilePadding: EdgeInsets.zero,
        childrenPadding: const EdgeInsets.only(top: 8),
        leading: FutureBuilder<UserProfileModel?>(
          future: context.read<PitchesCubit>().getFixerDetails(task.assignedFixerId),
          builder: (context, snapshot) {
            return CircleAvatar(
              radius: 16,
              backgroundColor: Colors.blue.shade100,
              backgroundImage: (snapshot.hasData &&
                      snapshot.data?.profileImageUrl != null)
                  ? NetworkImage(snapshot.data!.profileImageUrl!)
                  : null,
              child: (snapshot.hasData &&
                      snapshot.data?.profileImageUrl != null)
                  ? null
                  : Icon(Icons.person, color: Colors.blue.shade600, size: 16),
            );
          },
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Assigned to',
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey[500],
                fontWeight: FontWeight.w500,
              ),
            ),
            Text(
              task.assignedFixerName!,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
            ),
          ],
        ),
        trailing: Icon(Icons.expand_more, color: Colors.grey[600]),
        children: [
          TaskDetailsSection(task: task),
          const SizedBox(height: 12),
          TaskStatusSection(),
        ],
      ),
    );
  }
}
