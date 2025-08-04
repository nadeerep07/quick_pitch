
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quick_pitch_app/core/common/main_background_painter.dart';
import 'package:quick_pitch_app/core/config/responsive.dart';
import 'package:quick_pitch_app/features/explore/fixer/repository/fixer_explore_repository.dart';
import 'package:quick_pitch_app/features/explore/fixer/view/components/active_filters.dart';
import 'package:quick_pitch_app/features/explore/fixer/view/components/filter_chips.dart';
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
                    const SearchBar(),
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

class SearchBar extends StatefulWidget {
  const SearchBar({super.key});

  @override
  State<SearchBar> createState() => _SearchBarState();
}

class _SearchBarState extends State<SearchBar> {
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    final state = context.read<FixerExploreCubit>().state;
    _controller = TextEditingController(text: state.searchQuery);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<FixerExploreCubit>();
    final state = context.watch<FixerExploreCubit>().state;
 final res = Responsive(context);
    if (_controller.text != state.searchQuery) {
      _controller.value = _controller.value.copyWith(
        text: state.searchQuery,
        selection: TextSelection.collapsed(offset: state.searchQuery.length),
      );
    }

    return Container(
      width: res.wp(90) ,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            spreadRadius: 1,
          ),
        ],
      ),
      child: TextField(
        controller: _controller,
        decoration: InputDecoration(
          filled: true,
          fillColor: Colors.white,
          prefixIcon: const Icon(Icons.search_rounded, color: Colors.grey),
          hintText: 'Search for services...',
          hintStyle: TextStyle(color: Colors.grey.shade500),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
          contentPadding: const EdgeInsets.symmetric(vertical: 16),
          suffixIcon:
              state.searchQuery.isNotEmpty
                  ? IconButton(
                    icon: const Icon(Icons.clear_rounded, color: Colors.grey),
                    onPressed: () => cubit.updateSearchQuery(''),
                  )
                  : null,
        ),
        onTap: () => cubit.toggleSearchHistory(true),
        onChanged: cubit.updateSearchQuery,
        style: const TextStyle(fontWeight: FontWeight.w500),
      ),
    );
  }
}
