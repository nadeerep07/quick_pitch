
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quick_pitch_app/core/common/main_background_painter.dart';
import 'package:quick_pitch_app/features/explore/fixer/repository/fixer_explore_repository.dart';
import 'package:quick_pitch_app/features/explore/fixer/view/components/active_filters.dart';
import 'package:quick_pitch_app/features/explore/fixer/view/components/filter_chips.dart';
import 'package:quick_pitch_app/features/explore/fixer/view/components/fixer_explore_search_bar.dart';
import 'package:quick_pitch_app/features/explore/fixer/view/components/tasks_grid.dart';
import 'package:quick_pitch_app/features/explore/fixer/viewmodel/cubit/fixer_explore_cubit.dart';

class FixerExploreScreen extends StatelessWidget {
  const FixerExploreScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => FixerExploreCubit(FixerExploreRepositoryImpl()),
      child: const _FixerExploreView(),
    );
  }
}

class _FixerExploreView extends StatelessWidget {
  const _FixerExploreView();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          'Explore Services',
          style: TextStyle(
            fontWeight: FontWeight.w600,
            color: Colors.black87,
            fontSize: 20,
          ),
        ),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.black,
        iconTheme: const IconThemeData(color: Colors.black87),
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          return Stack(
            children: [
              CustomPaint(
                painter: MainBackgroundPainter(),
                size: Size.infinite,
              ),
              Container(
                width: constraints.maxWidth,
                height: constraints.maxHeight,
                padding: const EdgeInsets.symmetric(
                  horizontal: 1.0,
                  vertical: 2.0,
                ),
                child: Column(
                  children: [
                    const FixerExploreSearchBar(),
                    const SizedBox(height: 16),
                    const FilterChips(),
                    const SizedBox(height: 16),
                    const ActiveFilters(),
                    const SizedBox(height: 16),
                    Expanded(child: TasksGrid()),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}


