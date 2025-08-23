import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:quick_pitch_app/features/profile_completion/model/user_profile_model.dart';
import 'package:quick_pitch_app/features/explore/poster/repository/poster_explore_repository.dart';
import 'package:quick_pitch_app/features/explore/poster/viewmodel/cubit/poster_explore_cubit.dart';
import 'package:quick_pitch_app/features/explore/poster/viewmodel/cubit/poster_explore_state.dart';
import 'package:quick_pitch_app/core/config/app_colors.dart';

class FixerCard extends StatelessWidget {
  final UserProfileModel fixer;
  final Position? posterLocation;

  const FixerCard({
    super.key,
    required this.fixer,
    required this.posterLocation,
  });

  String _getDistance() {
    if (posterLocation == null || 
        fixer.fixerData?.latitude == null || 
        fixer.fixerData?.longitude == null ||
        fixer.fixerData!.latitude == 0.0 ||
        fixer.fixerData!.longitude == 0.0) {
      return '';
    }

    final distance = PosterExploreRepository.haversineKm(
      posterLocation!.latitude,
      posterLocation!.longitude,
      fixer.fixerData!.latitude,
      fixer.fixerData!.longitude,
    );

    if (distance < 1) {
      return '${(distance * 1000).round()}m';
    } else {
      return '${distance.toStringAsFixed(1)}km';
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PosterExploreCubit, PosterExploreState>(
      builder: (context, state) {
        // Load works if not already loaded
        if (state is PosterExploreLoaded) {
          final works = state.getFixerWorks(fixer.uid);
          if (works.isEmpty) {
            context.read<PosterExploreCubit>().loadFixerWorks(fixer.uid);
          }
        }

        final distance = _getDistance();
        
        return Container(
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
          child: Card(
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.06),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header Row
                  Row(
                    children: [
                      // Profile Image
                      CircleAvatar(
                        radius: 24,
                        backgroundColor: AppColors.primary.withOpacity(0.1),
                        backgroundImage: fixer.profileImageUrl != null
                            ? NetworkImage(fixer.profileImageUrl!)
                            : null,
                        child: fixer.profileImageUrl == null
                            ? Text(
                                fixer.name.isNotEmpty ? fixer.name[0].toUpperCase() : 'F',
                                style: const TextStyle(
                                  color: AppColors.primary,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                ),
                              )
                            : null,
                      ),
                      const SizedBox(width: 12),
                      
                      // Name and Details
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              fixer.name,
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: AppColors.primaryText,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Row(
                              children: [
                                // Rating
                                Row(
                                  children: [
                                    const Icon(
                                      Icons.star,
                                      size: 16,
                                      color: Colors.amber,
                                    ),
                                    const SizedBox(width: 4),
                                    const Text(
                                      '4.8',
                                      style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ],
                                ),
                                
                                // Distance
                                if (distance.isNotEmpty) ...[
                                  const SizedBox(width: 12),
                                  Row(
                                    children: [
                                      Icon(
                                        Icons.location_on,
                                        size: 16,
                                        color: Colors.grey[500],
                                      ),
                                      const SizedBox(width: 2),
                                      Text(
                                        distance,
                                        style: TextStyle(
                                          fontSize: 14,
                                          color: Colors.grey[600],
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ],
                            ),
                          ],
                        ),
                      ),
                      
                      // Message Button
                      Container(
                        decoration: BoxDecoration(
                          color: AppColors.primary,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: IconButton(
                          onPressed: () {
                            // Handle message action
                          },
                          icon: const Icon(
                            Icons.message,
                            color: Colors.white,
                            size: 20,
                          ),
                        ),
                      ),
                    ],
                  ),
                  
                  const SizedBox(height: 12),
                  
                  // Skills
                  if (fixer.fixerData?.skills != null && fixer.fixerData!.skills!.isNotEmpty) ...[
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: fixer.fixerData!.skills!.take(3).map((skill) {
                        return Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.primary.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            skill,
                            style: const TextStyle(
                              color: AppColors.primary,
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: 12),
                  ],
                  
                  // Recent Works Section
                  BlocBuilder<PosterExploreCubit, PosterExploreState>(
                    builder: (context, state) {
                      if (state is PosterExploreLoaded) {
                        final works = state.getFixerWorks(fixer.uid);
                        
                        return Column(
                          children: [
                            Row(
                              children: [
                                const Text(
                                  'Recent Works',
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                    color: AppColors.primaryText,
                                  ),
                                ),
                                const Spacer(),
                                if (works.isNotEmpty)
                                  TextButton(
                                    onPressed: () {
                                      // Navigate to all works
                                    },
                                    child: Text(
                                      'View All (${works.length})',
                                      style: const TextStyle(
                                        fontSize: 12,
                                        color: AppColors.primary,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                            
                            const SizedBox(height: 8),
                            
                            // Recent Works Preview
                            works.isEmpty 
                                ? Container(
                                    height: 60,
                                    child: Center(
                                      child: Text(
                                        'No recent works',
                                        style: TextStyle(
                                          color: Colors.grey[500],
                                          fontSize: 12,
                                        ),
                                      ),
                                    ),
                                  )
                                : SizedBox(
                                    height: 100,
                                    child: ListView.builder(
                                      scrollDirection: Axis.horizontal,
                                      itemCount: works.take(3).length,
                                      itemBuilder: (context, index) {
                                        final work = works[index];
                                        return Container(
                                          width: 120,
                                          margin: const EdgeInsets.only(right: 12),
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Expanded(
                                                child: Container(
                                                  decoration: BoxDecoration(
                                                    color: Colors.grey[200],
                                                    borderRadius: BorderRadius.circular(8),
                                                    image: work.images.isNotEmpty 
                                                        ? DecorationImage(
                                                            image: NetworkImage(work.images.first),
                                                            fit: BoxFit.cover,
                                                          )
                                                        : null,
                                                  ),
                                                  child: work.images.isEmpty 
                                                      ? Center(
                                                          child: Icon(
                                                            Icons.work,
                                                            color: Colors.grey[400],
                                                            size: 32,
                                                          ),
                                                        )
                                                      : null,
                                                ),
                                              ),
                                              const SizedBox(height: 4),
                                              Text(
                                                work.title,
                                                style: const TextStyle(
                                                  fontSize: 11,
                                                  fontWeight: FontWeight.w500,
                                                ),
                                                maxLines: 1,
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                              Text(
                                                '₹${work.amount.toInt()}',
                                                style: const TextStyle(
                                                  fontSize: 10,
                                                  color: AppColors.primary,
                                                  fontWeight: FontWeight.w600,
                                                ),
                                              ),
                                            ],
                                          ),
                                        );
                                      },
                                    ),
                                  ),
                          ],
                        );
                      }
                      return const SizedBox.shrink();
                    },
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}