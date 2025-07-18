import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quick_pitch_app/features/explore/fixer/viewmodel/cubit/explore_screen_cubit.dart';

class FixerExploreScreenSearchBar extends StatelessWidget {
  const FixerExploreScreenSearchBar({
    super.key,
    required TextEditingController searchController,
  }) : _searchController = searchController;

  final TextEditingController _searchController;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ExploreScreenCubit, ExploreScreenState>(
      builder: (context, state) {
        return TextField(
          controller: _searchController,
          onChanged: (value) => context.read<ExploreScreenCubit>().updateSearchQuery(value),
          decoration: InputDecoration(
            hintText: 'Search tasks...',
            prefixIcon: const Icon(Icons.search),
            suffixIcon: state.searchQuery.isNotEmpty
                ? IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () {
                      _searchController.clear();
                      context.read<ExploreScreenCubit>().updateSearchQuery('');
                      FocusScope.of(context).unfocus();
                    },
                  )
                : null,
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
            filled: true,
            fillColor: Colors.white,
          ),
        );
      },
    );
  }
}
