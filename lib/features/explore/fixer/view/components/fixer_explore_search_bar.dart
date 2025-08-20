import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quick_pitch_app/core/config/responsive.dart';
import 'package:quick_pitch_app/features/explore/fixer/viewmodel/cubit/fixer_explore_cubit.dart';

class FixerExploreSearchBar extends StatefulWidget {
  const FixerExploreSearchBar({super.key});

  @override
  State<FixerExploreSearchBar> createState() => _FixerExploreSearchBarState();
}

class _FixerExploreSearchBarState extends State<FixerExploreSearchBar> {
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