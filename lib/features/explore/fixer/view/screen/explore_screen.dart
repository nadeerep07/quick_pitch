import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quick_pitch_app/core/common/main_background_painter.dart';
import 'package:quick_pitch_app/core/config/responsive.dart';
import 'package:quick_pitch_app/features/explore/fixer/view/components/explore_task_shimmer.dart';
import 'package:quick_pitch_app/features/explore/fixer/view/components/fixer_explore_screen_app_bar.dart';
import 'package:quick_pitch_app/features/explore/fixer/view/components/fixer_explore_screen_search_bar.dart';
import 'package:quick_pitch_app/features/explore/fixer/view/components/fixer_explore_task_card.dart';
import 'package:quick_pitch_app/features/explore/fixer/view/components/fixer_filter_chips.dart';
import 'package:quick_pitch_app/features/explore/fixer/viewmodel/cubit/explore_screen_cubit.dart';

class ExploreScreen extends StatefulWidget {
  const ExploreScreen({super.key});

  @override
  State<ExploreScreen> createState() => _ExploreScreenState();
}

class _ExploreScreenState extends State<ExploreScreen> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final res = Responsive(context);

    return Scaffold(
      appBar: FixerExploreScreenAppBar(),
      body: Stack(
        children: [
          CustomPaint(painter: MainBackgroundPainter(), size: Size.infinite),
          Padding(
            padding: EdgeInsets.all(res.wp(4)),
            child: Column(
              children: [
                FixerExploreScreenSearchBar(searchController: _searchController),
                SizedBox(height: res.hp(1.5)),
                FixerFilterChips(context: context),
                SizedBox(height: res.hp(2)),
                _buildTaskGrid(res),
              ],
            ),
          ),
        ],
      ),
    );
  }


 Widget _buildTaskGrid(Responsive res) {
  return Expanded(
    child: BlocBuilder<ExploreScreenCubit, ExploreScreenState>(
      builder: (context, state) {
        if (state.isLoading) {
          return const ExploreTasksShimmer();
        }

        return RefreshIndicator(
          onRefresh: () async {
            await context.read<ExploreScreenCubit>().fetchCategoryMatchedTasks();
          },
          child: state.filteredTasks.isEmpty
              ? ListView( // RefreshIndicator needs a scrollable widget
                  physics: const AlwaysScrollableScrollPhysics(),
                  children: const [
                    SizedBox(height: 100),
                    Center(child: Text("No tasks match.")),
                  ],
                )
              : GridView.builder(
                  padding: EdgeInsets.only(bottom: res.hp(2)),
                  physics: const AlwaysScrollableScrollPhysics(),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: res.wp(3),
                    mainAxisSpacing: res.hp(2),
                    childAspectRatio: 0.85,
                  ),
                  itemCount: state.filteredTasks.length,
                  itemBuilder: (context, index) {
                    final task = state.filteredTasks[index];
                    return FixerExploreTaskCard(
                      context: context,
                      task: task,
                      res: res,
                    );
                  },
                ),
        );
      },
    ),
  );
}

}
