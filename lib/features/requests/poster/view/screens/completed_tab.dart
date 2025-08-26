import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quick_pitch_app/core/common/date_formatter.dart';
import 'package:quick_pitch_app/features/requests/poster/viewmodel/cubit/pitches_state.dart';
import 'package:quick_pitch_app/features/task_pitching/model/pitch_model.dart';
import 'package:quick_pitch_app/features/poster_task/model/task_post_model.dart';
import 'package:quick_pitch_app/features/profile_completion/model/user_profile_model.dart';

class CompletedTab extends StatelessWidget {
  const CompletedTab({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PitchesCubit, PitchesState>(
      builder: (context, state) {
        if (state is PitchesLoading) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        if (state is PitchesError) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.error_outline,
                  size: 64,
                  color: Colors.red.shade300,
                ),
                const SizedBox(height: 16),
                Text(
                  'Error loading completed tasks',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 8),
                Text(
                  state.message,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Colors.grey.shade600,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          );
        }

        if (state is PitchesLoaded) {
          if (state.completed.isEmpty) {
            return _buildEmptyState(context);
          }

          return RefreshIndicator(
            onRefresh: () async {
              context.read<PitchesCubit>().listenToPitches();
            },
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: state.completed.length,
              itemBuilder: (context, index) {
                final item = state.completed[index];
                final task = item['task'] as TaskPostModel;
                final pitches = item['pitches'] as List<PitchModel>;
                
                return CompletedTaskCard(
                  task: task,
                  pitches: pitches,
                );
              },
            ),
          );
        }

        return _buildEmptyState(context);
      },
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 120,
            height: 120,
            decoration: BoxDecoration(
              color: Colors.green.shade50,
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.task_alt_rounded,
              size: 64,
              color: Colors.green.shade400,
            ),
          ),
          const SizedBox(height: 24),
          Text(
            'No completed tasks yet',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Your completed tasks will appear here once\nfixers finish working on them.',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Colors.grey.shade600,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

class CompletedTaskCard extends StatelessWidget {
  final TaskPostModel task;
  final List<PitchModel> pitches;

  const CompletedTaskCard({
    super.key,
    required this.task,
    required this.pitches,
  });

  @override
  Widget build(BuildContext context) {
    final acceptedPitch = pitches.firstWhere(
      (p) => p.status == 'accepted' || p.status == 'completed',
      orElse: () => pitches.first,
    );

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Colors.green.withOpacity(0.1),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(context, acceptedPitch),
            const SizedBox(height: 16),
            _buildTaskTitle(context),
            const SizedBox(height: 12),
            
            // Expandable section with fixer info and details
            Theme(
              data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
              child: ExpansionTile(
                tilePadding: EdgeInsets.zero,
                childrenPadding: const EdgeInsets.only(top: 8),
                leading: FutureBuilder<UserProfileModel?>(
                  future: context.read<PitchesCubit>().getFixerDetails(acceptedPitch.fixerId),
                  builder: (context, snapshot) {
                    return CircleAvatar(
                      radius: 16,
                      backgroundColor: Colors.blue.shade100,
                      backgroundImage: (snapshot.hasData && 
                                      snapshot.data != null && 
                                      snapshot.data!.profileImageUrl != null)
                          ? NetworkImage(snapshot.data!.profileImageUrl!)
                          : null,
                      child: (snapshot.hasData && 
                              snapshot.data != null && 
                              snapshot.data!.profileImageUrl != null)
                          ? null
                          : Icon(
                              Icons.person,
                              color: Colors.blue.shade600,
                              size: 16,
                            ),
                    );
                  },
                ),
                title: FutureBuilder<UserProfileModel?>(
                  future: context.read<PitchesCubit>().getFixerDetails(acceptedPitch.fixerId),
                  builder: (context, snapshot) {
                    final fixerName = (snapshot.hasData && snapshot.data != null)
                        ? snapshot.data!.name
                        : 'Fixer';
                    
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Completed by',
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: Colors.grey.shade500,
                            fontSize: 11,
                          ),
                        ),
                        Text(
                          fixerName,
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            fontWeight: FontWeight.w600,
                            color: Colors.grey.shade700,
                          ),
                        ),
                      ],
                    );
                  },
                ),
                trailing: Icon(
                  Icons.expand_more,
                  color: Colors.grey[600],
                ),
                children: [
                  // Completion note section
                  if (acceptedPitch.completionNotes != null || acceptedPitch.latestUpdate != null) ...[
                    _buildCompletionNote(context, acceptedPitch),
                    const SizedBox(height: 12),
                  ],
                  
                  // Payment status section
                  _buildPaymentStatus(context, acceptedPitch),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context, PitchModel acceptedPitch) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: Colors.green.shade50,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: Colors.green.shade200,
              width: 1,
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 6,
                height: 6,
                decoration: BoxDecoration(
                  color: Colors.green,
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 6),
              Text(
                'Completed',
                style: TextStyle(
                  color: Colors.green.shade700,
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
        if (acceptedPitch.completionDate != null)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: Colors.grey.shade50,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
             DateFormatter.format(acceptedPitch.completionDate!),
              style: TextStyle(
                color: Colors.grey.shade600,
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildTaskTitle(BuildContext context) {
    return Text(
      task.title,
      style: Theme.of(context).textTheme.titleMedium?.copyWith(
        fontWeight: FontWeight.w700,
        color: Colors.grey.shade800,
        height: 1.3,
      ),
      maxLines: 2,
      overflow: TextOverflow.ellipsis,
    );
  }

  Widget _buildCompletionNote(BuildContext context, PitchModel acceptedPitch) {
    final note = acceptedPitch.completionNotes ?? 
                 acceptedPitch.latestUpdate ?? 
                 'Task completed successfully';

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.blue.shade50,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Colors.blue.shade100,
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.sticky_note_2_outlined,
                size: 14,
                color: Colors.blue.shade600,
              ),
              const SizedBox(width: 6),
              Text(
                'Completion Note',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Colors.blue.shade700,
                  fontWeight: FontWeight.w600,
                  fontSize: 11,
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            note,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: Colors.blue.shade600,
              height: 1.4,
            ),
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  Widget _buildPaymentStatus(BuildContext context, PitchModel acceptedPitch) {
    final isPaid = acceptedPitch.paymentStatus == 'paid';
    
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: isPaid ? Colors.green.shade50 : Colors.orange.shade50,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isPaid ? Colors.green.shade200 : Colors.orange.shade200,
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              color: isPaid ? Colors.green.shade100 : Colors.orange.shade100,
              shape: BoxShape.circle,
            ),
            child: Icon(
              isPaid ? Icons.check_circle : Icons.schedule,
              size: 16,
              color: isPaid ? Colors.green.shade700 : Colors.orange.shade700,
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Payment Status',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: isPaid ? Colors.green.shade600 : Colors.orange.shade600,
                    fontSize: 11,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Text(
                  isPaid ? 'Payment Completed' : 'Payment Pending',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: isPaid ? Colors.green.shade700 : Colors.orange.shade700,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
          if (!isPaid)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.orange.shade100,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                'Action Required',
                style: TextStyle(
                  color: Colors.orange.shade700,
                  fontSize: 10,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
        ],
      ),
    );
  }
}