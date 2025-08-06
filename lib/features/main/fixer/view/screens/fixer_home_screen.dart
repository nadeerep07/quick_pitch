import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quick_pitch_app/core/common/main_background_painter.dart';
import 'package:quick_pitch_app/core/config/responsive.dart';
import 'package:quick_pitch_app/features/main/fixer/view/screens/components/fixer_home_empty_state.dart';
import 'package:quick_pitch_app/features/main/fixer/view/screens/components/fixer_home_error_state.dart';
import 'package:quick_pitch_app/features/main/fixer/view/screens/components/fixer_home_filter_section.dart';
import 'package:quick_pitch_app/features/main/fixer/view/screens/components/fixer_home_shimmer.dart';
import 'package:quick_pitch_app/features/main/fixer/view/screens/components/fixer_home_state_section.dart';
import 'package:quick_pitch_app/features/main/fixer/view/screens/components/fixer_home_user_header.dart';
import 'package:quick_pitch_app/features/main/fixer/view/screens/components/fixer_task_card.dart';
import 'package:quick_pitch_app/features/main/fixer/viewmodel/cubit/fixer_home_cubit.dart';

class FixerHomeScreen extends StatefulWidget {
  final GlobalKey<ScaffoldState> scaffoldKey;
  const FixerHomeScreen({super.key, required this.scaffoldKey});

  @override
  State<FixerHomeScreen> createState() => _FixerHomeScreenState();
}

class _FixerHomeScreenState extends State<FixerHomeScreen> {
  Set<String> selectedFilters = {};

  @override
  void initState() {
    super.initState();
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid != null) {
      context.read<FixerHomeCubit>().loadFixerHomeData(uid);
    }
  }

  @override
  Widget build(BuildContext context) {
    final res = Responsive(context);

    return Container(
      decoration: const BoxDecoration(color: Colors.transparent),
      child: CustomPaint(
        painter: MainBackgroundPainter(),
        child: SafeArea(
          bottom: true,
          child: RefreshIndicator(
            onRefresh: () async {
              final uid = FirebaseAuth.instance.currentUser?.uid;
              if (uid != null) {
                context.read<FixerHomeCubit>().loadFixerHomeData(uid);
              }
            },
            child: BlocBuilder<FixerHomeCubit, FixerHomeState>(
              builder: (context, state) {
                if (state is FixerHomeLoading) {
                  return FixerHomeShimmer(res: res);
                }

                if (state is FixerHomeLoaded) {
                  return CustomScrollView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    slivers: [
                      SliverToBoxAdapter(
                        child: FixerHomeUserHeader(widget: widget, context: context, res: res, state: state),
                      ),
                      SliverToBoxAdapter(
                        child: FixerHomeStateSection(res: res, state: state),
                      ),
                      SliverToBoxAdapter(
                        child: FixerHomeFilterSection(res: res),
                      ),
                      SliverToBoxAdapter(
                        child: _buildTasksSection(res, state),
                      ),
                      const SliverToBoxAdapter(child: SizedBox(height: 100)),
                    ],
                  );
                }

                if (state is FixerHomeError) {
                  return FixerHomeErrorState(context: context, state: state);
                }

                return const Center(child: Text("Loading..."));
              },
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTasksSection(Responsive res, FixerHomeLoaded state) {
    var filteredTasks = context.read<FixerHomeCubit>().getFilteredTasks();

    if (selectedFilters.isNotEmpty) {
      filteredTasks = state.newTasks.where((task) {
        return task.skills.any((skill) => selectedFilters.contains(skill));
      }).toList();
    }

    if (filteredTasks.isEmpty) {
      return Container(
        margin: EdgeInsets.all(res.wp(5)),
        child: FixerHomeEmptyState(
          res: res,
          title: selectedFilters.isEmpty ? 'No Tasks Available' : 'No Matching Tasks',
          subtitle: selectedFilters.isEmpty
              ? 'Check back later for new opportunities'
              : 'Try adjusting your filters',
          icon: Icons.work_outline,
        ),
      );
    }

    return Container(
      margin: EdgeInsets.fromLTRB(res.wp(5), res.hp(3), res.wp(5), 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Active Tasks',
                style: TextStyle(
                  fontSize: res.sp(16),
                  fontWeight: FontWeight.w700,
                  color: const Color(0xFF1E293B),
                ),
              ),
              Text(
                '${filteredTasks.length} tasks',
                style: TextStyle(
                  fontSize: res.sp(12),
                  color: const Color(0xFF64748B),
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          SizedBox(height: res.hp(1.5)),
          ...filteredTasks.map((task) => FixerTaskCard(task: task, res: res)),
        ],
      ),
    );
  }
}
