import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:quick_pitch_app/core/common/main_background_painter.dart';
import 'package:quick_pitch_app/core/config/responsive.dart';
import 'package:quick_pitch_app/features/task_detail/poster/view/components/build_app_bar.dart';
import 'package:quick_pitch_app/features/task_detail/poster/view/components/build_chip.dart';
import 'package:quick_pitch_app/features/task_detail/poster/view/components/build_image_carousel.dart';
import 'package:quick_pitch_app/features/task_detail/poster/view/components/info_card.dart';
import 'package:quick_pitch_app/features/task_detail/poster/view/components/section_card.dart';
import 'package:quick_pitch_app/features/task_detail/poster/view/components/shimmer_task_dettail_view.dart';
import 'package:quick_pitch_app/features/task_detail/poster/viewmodel/cubit/task_details_cubit.dart';

class PosterTaskDetailScreen extends StatefulWidget {
  final String taskId;

  const PosterTaskDetailScreen({super.key, required this.taskId});

  @override
  State<PosterTaskDetailScreen> createState() => _PosterTaskDetailScreenState();
}

class _PosterTaskDetailScreenState extends State<PosterTaskDetailScreen> {
  final _pageController = PageController();
  final _pageNotifier = ValueNotifier<int>(0);

  @override
  void initState() {
    super.initState();
    context.read<TaskDetailsCubit>().loadTaskById(widget.taskId);
  }

  @override
  Widget build(BuildContext context) {
    final res = Responsive(context);

    return Scaffold(
      body: BlocBuilder<TaskDetailsCubit, TaskDetailsState>(
        builder: (context, state) {
          if (state is TaskDetailLoading) {
            return ShimmerTaskDetail();
          } else if (state is TaskDetailError) {
            return Center(child: Text(state.message));
          } else if (state is TaskDetailLoaded) {
            final task = state.task;
            final createdDate = DateFormat(
              'MMM d, yyyy  h:mm a',
            ).format(task.createdAt);
            final deadlineDate = DateFormat(
              'MMM d, yyyy',
            ).format(task.deadline);

            return CustomPaint(
              painter: MainBackgroundPainter(),
              child: SafeArea(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      BuildAppBar(
                        task: task,
                        res: res,
                        onTaskDeleted: () {
                          Navigator.pop(context, true);
                        },
                      ),
                      const SizedBox(height: 12),
                      if (task.imagesUrl != null && task.imagesUrl!.isNotEmpty)
                        BuildImageCarousel(
                          pageController: _pageController,
                          pageNotifier: _pageNotifier,
                          images: task.imagesUrl!,
                          res: res,
                        ),
                      const SizedBox(height: 12),
                      Text(
                        task.title,
                        style: TextStyle(
                          fontSize: res.sp(20),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Wrap(
                        spacing: 8,
                        children: [
                          BuildChip(
                            label: "Status: ${task.status}",
                            color: _statusColor(task.status),
                          ),
                          BuildChip(
                            label: "Work: ${task.workType}",
                            color: Colors.blueAccent,
                          ),
                          BuildChip(
                            label: "Priority: ${task.priority}",
                            color: Colors.purple,
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      SectionCard(
                        title: "Description",
                        value: task.description,
                        res: res,
                      ),
                      const SizedBox(height: 16),
                      if(task.location != null)
                      InfoCard(title: "Location", value: task.location ?? 'Remote'),
                      InfoCard(title: "Budget", value: "₹ ${task.budget}"),
                      InfoCard(
                        title: "Preferred Time",
                        value: task.preferredTime,
                      ),
                      const SizedBox(height: 12),
                      InfoCard(title: "Deadline", value: deadlineDate),
                      InfoCard(title: "Posted On", value: createdDate),
                      const SizedBox(height: 12),
                      if (task.assignedFixerName != null &&
                          task.assignedFixerName!.isNotEmpty) ...[
                        SectionCard(
                          title: "Assigned Fixer",
                          value: "",
                          res: res,
                        ),
                        InfoCard(title: "Name", value: task.assignedFixerName!),
                        InfoCard(
                          title: "Fixer ID",
                          value: task.assignedFixerId ?? '',
                        ),
                      ],
                      const SizedBox(height: 12),
                      Text(
                        "Required Skills",
                        style: TextStyle(
                          fontSize: res.sp(16),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Wrap(
                        spacing: 8,
                        runSpacing: 6,
                        children:
                            task.skills
                                .map(
                                  (s) => Chip(
                                    label: Text(s),
                                    backgroundColor: Colors.teal.shade100,
                                  ),
                                )
                                .toList(),
                      ),
                      const SizedBox(height: 32),
                    ],
                  ),
                ),
              ),
            );
          }
          return const SizedBox();
        },
      ),
    );
  }

  Color _statusColor(String status) {
    switch (status.toLowerCase()) {
      case 'completed':
        return Colors.green;
      case 'pending':
        return Colors.orange;
      case 'rejected':
        return Colors.redAccent;
      default:
        return Colors.blueGrey;
    }
  }
}
