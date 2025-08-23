import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:geolocator/geolocator.dart';
import 'package:quick_pitch_app/core/config/app_colors.dart';
import 'package:quick_pitch_app/core/config/responsive.dart';
import 'package:quick_pitch_app/features/explore/poster/repository/poster_explore_repository.dart';
import 'package:quick_pitch_app/features/explore/poster/view/widgets/fixer_work_page.dart';
import 'package:quick_pitch_app/features/fixer_work_upload/model/fixer_work_upload_model.dart';
import 'package:quick_pitch_app/features/profile_completion/model/user_profile_model.dart';

class ExploreListFixerCard extends StatefulWidget {
  final UserProfileModel fixer;
  final Position? posterLocation;

  const ExploreListFixerCard({
    super.key,
    required this.fixer,
    required this.posterLocation,
  });

  @override
  State<ExploreListFixerCard> createState() => _ExploreListFixerCardState();
}

class _ExploreListFixerCardState extends State<ExploreListFixerCard> {
  List<FixerWork> _recentWorks = [];
  bool _isLoadingWorks = true;
  int _totalWorksCount = 0;

  @override
  void initState() {
    super.initState();
    _loadFixerWorks();
  }

  Future<void> _loadFixerWorks() async {
    try {
      // Get total count first
      final countQuery = await FirebaseFirestore.instance
          .collection('fixer_works')
          .where('fixerId', isEqualTo: widget.fixer.uid)
          .get();
      
      _totalWorksCount = countQuery.docs.length;

      // Get recent works (limit to 3 for preview)
      final worksQuery = await FirebaseFirestore.instance
          .collection('fixer_works')
          .where('fixerId', isEqualTo: widget.fixer.uid)
          .orderBy('createdAt', descending: true)
          .limit(3)
          .get();

      _recentWorks = worksQuery.docs
          .map((doc) => FixerWork.fromFirestore(doc))
          .toList();

      if (mounted) {
        setState(() {
          _isLoadingWorks = false;
        });
      }
    } catch (e) {
      print('Error loading fixer works: $e');
      if (mounted) {
        setState(() {
          _isLoadingWorks = false;
        });
      }
    }
  }

  String _getDistance() {
    if (widget.posterLocation == null || 
        widget.fixer.fixerData?.latitude == null || 
        widget.fixer.fixerData?.longitude == null ||
        widget.fixer.fixerData!.latitude == 0.0 ||
        widget.fixer.fixerData!.longitude == 0.0) {
      return '';
    }

    final distance = PosterExploreRepository.haversineKm(
      widget.posterLocation!.latitude,
      widget.posterLocation!.longitude,
      widget.fixer.fixerData!.latitude,
      widget.fixer.fixerData!.longitude,
    );

    if (distance < 1) {
      return '${(distance * 1000).round()}m';
    } else {
      return '${distance.toStringAsFixed(1)} km';
    }
  }

  void _navigateToAllWorks() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => FixerWorksPage(
          fixer: widget.fixer,
        ),
      ),
    );
  }

  Widget _buildWorkItem(FixerWork work, int index, Responsive res) {
    // Adjust item width based on screen size and number of items
    final screenWidth = res.width;
    final availableWidth = screenWidth - res.wp(8); // Account for card padding
    final itemWidth = _recentWorks.length == 1 
        ? availableWidth 
        : (availableWidth * 0.45).clamp(140.0, 180.0); // 45% of available width, clamped
    final imageHeight = res.hp(12); // 12% of screen height
    
    // Safe cache dimensions calculation
    final cacheWidth = itemWidth.isFinite && !itemWidth.isNaN ? (itemWidth * 2).clamp(100, 800).toInt() : 320;
    final cacheHeight = imageHeight.isFinite && !imageHeight.isNaN ? (imageHeight * 2).clamp(100, 600).toInt() : 200;

    return Container(
      width: itemWidth,
      margin: EdgeInsets.only(right: index < _recentWorks.length - 1 ? res.wp(3) : 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min, // Important: prevents overflow
        children: [
          // Image container with proper constraints
          SizedBox(
            height: imageHeight,
            width: itemWidth,
            child: work.images.isNotEmpty
                ? ClipRRect(
                    borderRadius: BorderRadius.circular(res.wp(2)),
                    child: Image.network(
                      work.images.first,
                      fit: BoxFit.cover,
                      width: itemWidth,
                      height: imageHeight,
                      cacheWidth: cacheWidth, // Safe cache dimensions
                      cacheHeight: cacheHeight,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          width: itemWidth,
                          height: imageHeight,
                          decoration: BoxDecoration(
                            color: Colors.grey[200],
                            borderRadius: BorderRadius.circular(res.wp(2)),
                          ),
                          child: Icon(
                            Icons.image_not_supported,
                            color: Colors.grey,
                            size: res.wp(10),
                          ),
                        );
                      },
                      loadingBuilder: (context, child, loadingProgress) {
                        if (loadingProgress == null) return child;
                        return Container(
                          width: itemWidth,
                          height: imageHeight,
                          decoration: BoxDecoration(
                            color: Colors.grey[200],
                            borderRadius: BorderRadius.circular(res.wp(2)),
                          ),
                          child: const Center(
                            child: CircularProgressIndicator(strokeWidth: 2),
                          ),
                        );
                      },
                    ),
                  )
                : Container(
                    width: itemWidth,
                    height: imageHeight,
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(res.wp(2)),
                    ),
                    child: Icon(
                      Icons.work,
                      color: Colors.grey,
                      size: res.wp(10),
                    ),
                  ),
          ),
          SizedBox(height: res.hp(0.8)),
          
          // Title - using Flexible to prevent overflow
          Flexible(
            child: Text(
              work.title,
              style: TextStyle(
                fontSize: res.sp(13),
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          SizedBox(height: res.hp(0.3)),
          
          // Description - using Flexible to prevent overflow
          Flexible(
            child: Text(
              work.description,
              style: TextStyle(
                fontSize: res.sp(11),
                color: Colors.grey[600],
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          SizedBox(height: res.hp(0.5)),
          
          // Time and Amount row - Fixed overflow issue with constrained width
          SizedBox(
            width: itemWidth,
            child: Row(
              mainAxisSize: MainAxisSize.max,
              children: [
                if (work.time.isNotEmpty) ...[
                  Icon(
                    Icons.access_time,
                    size: res.sp(10),
                    color: Colors.grey[500],
                  ),
                  SizedBox(width: res.wp(0.5)),
                  Expanded(
                    flex: 2,
                    child: Text(
                      work.time,
                      style: TextStyle(
                        fontSize: res.sp(10),
                        color: Colors.grey[600],
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  SizedBox(width: res.wp(1)),
                ],
                Expanded(
                  flex: 1,
                  child: Text(
                    '₹${work.amount.toStringAsFixed(0)}',
                    style: TextStyle(
                      fontSize: res.sp(13),
                      color: Colors.blue,
                      fontWeight: FontWeight.w700,
                    ),
                    textAlign: TextAlign.end,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRecentWorksSection(Responsive res) {
    if (_isLoadingWorks) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                'Recent Works',
                style: TextStyle(
                  fontSize: res.sp(16),
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
              ),
              const Spacer(),
              Container(
                width: res.wp(20),
                height: res.hp(2.5),
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(res.wp(1)),
                ),
              ),
            ],
          ),
          SizedBox(height: res.hp(1)),
          SizedBox(
            height: res.hp(18), // Increased height to accommodate content
            child: Row(
              children: List.generate(2, (index) {
                final itemWidth = (res.width - res.wp(8)) * 0.45; // 45% of available width
                return Container(
                  width: itemWidth,
                  margin: EdgeInsets.only(right: index == 0 ? res.wp(3) : 0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        height: res.hp(12),
                        width: itemWidth,
                        decoration: BoxDecoration(
                          color: Colors.grey[200],
                          borderRadius: BorderRadius.circular(res.wp(2)),
                        ),
                      ),
                      SizedBox(height: res.hp(0.8)),
                      Container(
                        width: itemWidth * 0.6,
                        height: res.hp(1.8),
                        decoration: BoxDecoration(
                          color: Colors.grey[200],
                          borderRadius: BorderRadius.circular(res.wp(1)),
                        ),
                      ),
                      SizedBox(height: res.hp(0.3)),
                      Container(
                        width: itemWidth * 0.8,
                        height: res.hp(1.5),
                        decoration: BoxDecoration(
                          color: Colors.grey[200],
                          borderRadius: BorderRadius.circular(res.wp(1)),
                        ),
                      ),
                    ],
                  ),
                );
              }),
            ),
          ),
        ],
      );
    }

    if (_recentWorks.isEmpty) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Recent Works',
            style: TextStyle(
              fontSize: res.sp(16),
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
          ),
          SizedBox(height: res.hp(2)),
          Container(
            height: res.hp(12),
            decoration: BoxDecoration(
              color: Colors.grey[100],
              borderRadius: BorderRadius.circular(res.wp(2)),
            ),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.work_outline,
                    size: res.wp(8),
                    color: Colors.grey[400],
                  ),
                  SizedBox(height: res.hp(1)),
                  Text(
                    'No works uploaded yet',
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: res.sp(14),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              'Recent Works',
              style: TextStyle(
                fontSize: res.sp(16),
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
            ),
            const Spacer(),
            TextButton(
              onPressed: _navigateToAllWorks,
              child: Text(
                'View All ($_totalWorksCount)',
                style: TextStyle(
                  fontSize: res.sp(14),
                  color: Colors.blue,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: res.hp(1)),
        SizedBox(
          height: res.hp(18), // Increased height to prevent overflow
          child: _recentWorks.length == 1
              ? _buildWorkItem(_recentWorks[0], 0, res)
              : ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: _recentWorks.length,
                  itemBuilder: (context, index) {
                    return _buildWorkItem(_recentWorks[index], index, res);
                  },
                ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final distance = _getDistance();
    final res = Responsive(context);
    
    return Container(
      margin: EdgeInsets.only(bottom: res.hp(2)),
      child: Card(
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(res.wp(4)),
        ),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(res.wp(4)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.04),
                blurRadius: res.wp(2),
                offset: Offset(0, res.hp(0.3)),
              ),
            ],
          ),
          padding: EdgeInsets.all(res.wp(4)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header Row
              Row(
                children: [
                  // Profile Image
                  CircleAvatar(
                    radius: res.wp(6.5),
                    backgroundColor: AppColors.primary.withOpacity(0.1),
                    backgroundImage: widget.fixer.profileImageUrl != null
                        ? NetworkImage(widget.fixer.profileImageUrl!)
                        : null,
                    child: widget.fixer.profileImageUrl == null
                        ? Text(
                            widget.fixer.name.isNotEmpty ? widget.fixer.name[0].toUpperCase() : 'F',
                            style: TextStyle(
                              color: AppColors.primary,
                              fontWeight: FontWeight.bold,
                              fontSize: res.sp(20),
                            ),
                          )
                        : null,
                  ),
                  SizedBox(width: res.wp(3)),
                  
                  // Name and Details
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.fixer.name,
                          style: TextStyle(
                            fontSize: res.sp(18),
                            fontWeight: FontWeight.w600,
                            color: Colors.black87,
                          ),
                        ),
                        SizedBox(height: res.hp(0.5)),
                        Row(
                          children: [
                            // Rating
                            Icon(
                              Icons.star,
                              size: res.sp(16),
                              color: Colors.amber,
                            ),
                            SizedBox(width: res.wp(1)),
                            Text(
                              '4.8',
                              style: TextStyle(
                                fontSize: res.sp(14),
                                fontWeight: FontWeight.w500,
                                color: Colors.black87,
                              ),
                            ),
                            
                            // Distance
                            if (distance.isNotEmpty) ...[
                              SizedBox(width: res.wp(3)),
                              Icon(
                                Icons.location_on,
                                size: res.sp(16),
                                color: Colors.blue,
                              ),
                              SizedBox(width: res.wp(0.5)),
                              Text(
                                distance,
                                style: TextStyle(
                                  fontSize: res.sp(14),
                                  color: Colors.black87,
                                ),
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
                      color: Colors.blue,
                      borderRadius: BorderRadius.circular(res.wp(2)),
                    ),
                    child: IconButton(
                      onPressed: () {
                        // Handle message action
                      },
                      icon: Icon(
                        Icons.message,
                        color: Colors.white,
                        size: res.sp(18),
                      ),
                    ),
                  ),
                ],
              ),
              
              SizedBox(height: res.hp(2)),
              
              // Skills
              if (widget.fixer.fixerData?.skills != null && widget.fixer.fixerData!.skills!.isNotEmpty) ...[
                Wrap(
                  spacing: res.wp(2),
                  runSpacing: res.hp(1),
                  children: widget.fixer.fixerData!.skills!.take(3).map((skill) {
                    return Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: res.wp(3),
                        vertical: res.hp(0.8),
                      ),
                      decoration: BoxDecoration(
                        color: Colors.blue.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(res.wp(4)),
                      ),
                      child: Text(
                        skill,
                        style: TextStyle(
                          color: Colors.blue,
                          fontSize: res.sp(14),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    );
                  }).toList(),
                ),
                SizedBox(height: res.hp(2)),
              ],
              
              // Recent Works Section
              _buildRecentWorksSection(res),
            ],
          ),
        ),
      ),
    );
  }
}