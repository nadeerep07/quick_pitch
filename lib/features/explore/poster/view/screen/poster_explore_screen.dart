// poster_explore_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:quick_pitch_app/features/explore/poster/repository/poster_explore_repository.dart';
import 'package:quick_pitch_app/features/explore/poster/service/poster_explore_service.dart';
import 'package:quick_pitch_app/features/explore/poster/view/screen/poster_explore_map_view.dart';
import 'package:quick_pitch_app/features/explore/poster/view/widgets/explore_list_fixer_card.dart';
import 'package:quick_pitch_app/features/explore/poster/viewmodel/cubit/poster_explore_cubit.dart';
import 'package:quick_pitch_app/features/explore/poster/viewmodel/cubit/poster_explore_state.dart';

import 'package:quick_pitch_app/core/config/app_colors.dart';
import 'package:quick_pitch_app/features/profile_completion/model/user_profile_model.dart';

class PosterExploreScreen extends StatelessWidget {
  const PosterExploreScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => PosterExploreCubit(
        service: PosterExploreService(PosterExploreRepository()),
      )..load(),
      child: const _PosterExploreView(),
    );
  }
}

class _PosterExploreView extends StatelessWidget {
  const _PosterExploreView();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: BlocBuilder<PosterExploreCubit, PosterExploreState>(
          builder: (context, state) {
            return Column(
              children: [
                // App Bar with Toggle
                
                Container(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    children: [
                      // Title and count
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Find Fixers',
                              style: TextStyle(
                                fontSize: 28,
                                fontWeight: FontWeight.bold,
                                color: AppColors.primaryText,
                              ),
                            ),
                            if (state is PosterExploreLoaded)
                              Text(
                                '${state.filteredFixers.length} available',
                                style: TextStyle(
                                  color: Colors.grey[600],
                                  fontSize: 14,
                                ),
                              ),
                          ],
                        ),
                      ),
                      
                      // Toggle Buttons
                      if (state is PosterExploreLoaded)
                        ViewToggleButton(
                          isMapView: state.isMapView,
                          onToggle: () => context.read<PosterExploreCubit>().toggleMapView(),
                        ),
                    ],
                  ),
                ),

                // Search Bar (only in list view)
                if (state is PosterExploreLoaded && !state.isMapView)
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 16),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.grey[100],
                        borderRadius: BorderRadius.circular(25),
                      ),
                      child: TextField(
                        onChanged: (query) => context.read<PosterExploreCubit>().updateSearch(query),
                        decoration: InputDecoration(
                          hintText: 'Search fixers, skills, or works...',
                          hintStyle: TextStyle(
                            color: Colors.grey[500], 
                            fontSize: 16,
                          ),
                          prefixIcon: Icon(
                            Icons.search, 
                            color: Colors.grey[500],
                            size: 22,
                          ),
                          border: InputBorder.none,
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 20, 
                            vertical: 12,
                          ),
                        ),
                      ),
                    ),
                  ),

                // Skills Filter (only in list view)
                if (state is PosterExploreLoaded && !state.isMapView && state.skills.isNotEmpty)
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                    height: 35,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: state.skills.length,
                      itemBuilder: (context, index) {
                        final skill = state.skills[index];
                        final isSelected = state.selectedSkills.contains(skill);
                        
                        return Container(
                          margin: const EdgeInsets.only(right: 8),
                          child: GestureDetector(
                            onTap: () => context.read<PosterExploreCubit>().toggleSkill(skill),
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 8,
                              ),
                              decoration: BoxDecoration(
                                color: isSelected ? Colors.blue.withOpacity(0.1) : Colors.grey[100],
                                borderRadius: BorderRadius.circular(18),
                                border: Border.all(
                                  color: isSelected ? Colors.blue : Colors.transparent,
                                  width: 1,
                                ),
                              ),
                              child: Text(
                                skill,
                                style: TextStyle(
                                  color: isSelected ? Colors.blue : Colors.grey[700],
                                  fontSize: 14,
                                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),

                // Content
                Expanded(
                  child: _buildContent(context, state),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildContent(BuildContext context, PosterExploreState state) {
    if (state is PosterExploreLoading) {
      return const Center(
        child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary),
        ),
      );
    } else if (state is PosterExploreError) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline,
              size: 64,
              color: Colors.grey[400],
            ),
            const SizedBox(height: 16),
            Text(
              'Something went wrong',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Colors.grey[600],
              ),
            ),
            const SizedBox(height: 8),
            Text(
              state.message,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[500],
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () => context.read<PosterExploreCubit>().load(),
              child: const Text('Try Again'),
            ),
          ],
        ),
      );
    } else if (state is PosterExploreLoaded) {
      return state.isMapView
          ? PosterExploreMapView(
              fixers: state.fixersWithLocation,
              posterLocation: state.posterLocation,
            )
          : PosterExploreListView(
              fixers: state.filteredFixers,
              posterLocation: state.posterLocation,
            );
    }
    
    return const SizedBox.shrink();
  }
}

// Updated ViewToggleButton to match screenshot
class ViewToggleButton extends StatelessWidget {
  final bool isMapView;
  final VoidCallback onToggle;

  const ViewToggleButton({
    super.key,
    required this.isMapView,
    required this.onToggle,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(25),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          // List Button
          AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            curve: Curves.easeInOut,
            child: GestureDetector(
              onTap: isMapView ? onToggle : null,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                decoration: BoxDecoration(
                  color: !isMapView 
                      ? Colors.white 
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: !isMapView
                      ? [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 4,
                            offset: const Offset(0, 2),
                          ),
                        ]
                      : null,
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    AnimatedSwitcher(
                      duration: const Duration(milliseconds: 200),
                      child: Icon(
                        Icons.view_list_rounded,
                        key: ValueKey(!isMapView),
                        color: !isMapView 
                            ? const Color(0xFF6366F1) 
                            : Colors.grey[500],
                        size: 20,
                      ),
                    ),
                    const SizedBox(width: 6),
                    AnimatedDefaultTextStyle(
                      duration: const Duration(milliseconds: 200),
                      style: TextStyle(
                        color: !isMapView 
                            ? const Color(0xFF1F2937) 
                            : Colors.grey[500],
                        fontWeight: !isMapView 
                            ? FontWeight.w600 
                            : FontWeight.w500,
                        fontSize: 14,
                      ),
                      child: const Text('List'),
                    ),
                  ],
                ),
              ),
            ),
          ),
          
          // Map Button
          AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            curve: Curves.easeInOut,
            child: GestureDetector(
              onTap: !isMapView ? onToggle : null,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                decoration: BoxDecoration(
                  color: isMapView 
                      ? Colors.white 
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: isMapView
                      ? [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 4,
                            offset: const Offset(0, 2),
                          ),
                        ]
                      : null,
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    AnimatedSwitcher(
                      duration: const Duration(milliseconds: 200),
                      child: Icon(
                        Icons.map_rounded,
                        key: ValueKey(isMapView),
                        color: isMapView 
                            ? const Color(0xFF10B981) 
                            : Colors.grey[500],
                        size: 20,
                      ),
                    ),
                    const SizedBox(width: 6),
                    AnimatedDefaultTextStyle(
                      duration: const Duration(milliseconds: 200),
                      style: TextStyle(
                        color: isMapView 
                            ? const Color(0xFF1F2937) 
                            : Colors.grey[500],
                        fontWeight: isMapView 
                            ? FontWeight.w600 
                            : FontWeight.w500,
                        fontSize: 14,
                      ),
                      child: const Text('Map'),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}


// PosterExploreListView with filtering support
class PosterExploreListView extends StatelessWidget {
  final List<UserProfileModel> fixers;
  final Position? posterLocation;

  const PosterExploreListView({
    super.key,
    required this.fixers,
    required this.posterLocation,
  });

  @override
  Widget build(BuildContext context) {
    if (fixers.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.search_off,
              size: 64,
              color: Colors.grey[400],
            ),
            const SizedBox(height: 16),
            Text(
              'No fixers found',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Colors.grey[600],
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Try again later',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[500],
              ),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      itemCount: fixers.length,
      itemBuilder: (context, index) {
        return ExploreListFixerCard(
          fixer: fixers[index],
          posterLocation: posterLocation,
        );
      },
    );
  }
}

// Updated FixerCard to match screenshot style
