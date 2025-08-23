// poster_explore_map_view.dart
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:quick_pitch_app/core/common/app_button.dart';
import 'package:quick_pitch_app/features/profile_completion/model/user_profile_model.dart';
import 'package:quick_pitch_app/features/explore/poster/repository/poster_explore_repository.dart';
import 'package:quick_pitch_app/core/config/app_colors.dart';

class PosterExploreMapView extends StatefulWidget {
  final List<UserProfileModel> fixers;
  final Position? posterLocation;

  const PosterExploreMapView({
    super.key,
    required this.fixers,
    required this.posterLocation,
  });

  @override
  State<PosterExploreMapView> createState() => _PosterExploreMapViewState();
}

class _PosterExploreMapViewState extends State<PosterExploreMapView> {
  GoogleMapController? _mapController;
  Set<Marker> _markers = {};
  UserProfileModel? _selectedFixer;

  @override
  void initState() {
    super.initState();
    _createMarkers();
  }

  @override
  void didUpdateWidget(PosterExploreMapView oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.fixers != widget.fixers) {
      _createMarkers();
    }
  }

  void _createMarkers() {
    final markers = <Marker>{};

    // Add poster location marker
    if (widget.posterLocation != null) {
      markers.add(
        Marker(
          markerId: const MarkerId('poster_location'),
          position: LatLng(
            widget.posterLocation!.latitude,
            widget.posterLocation!.longitude,
          ),
          icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
          infoWindow: const InfoWindow(
            title: 'Your Location',
            snippet: 'You are here',
          ),
        ),
      );
    }

    // Add fixer markers
    for (int i = 0; i < widget.fixers.length; i++) {
      final fixer = widget.fixers[i];
      if (fixer.fixerData?.latitude != null && 
          fixer.fixerData?.longitude != null &&
          fixer.fixerData!.latitude != 0.0 &&
          fixer.fixerData!.longitude != 0.0) {
        markers.add(
          Marker(
            markerId: MarkerId('fixer_${fixer.uid}'),
            position: LatLng(
              fixer.fixerData!.latitude,
              fixer.fixerData!.longitude,
            ),
            icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
            infoWindow: InfoWindow(
              title: fixer.name,
              snippet: fixer.fixerData?.skills?.take(2).join(', ') ?? '',
            ),
            onTap: () => _showFixerBottomSheet(fixer),
          ),
        );
      }
    }

    setState(() {
      _markers = markers;
    });
  }

  void _showFixerBottomSheet(UserProfileModel fixer) {
    setState(() {
      _selectedFixer = fixer;
    });

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => FixerBottomSheet(
        fixer: fixer,
        posterLocation: widget.posterLocation,
        onViewProfile: () {
          Navigator.pop(context);
          // Navigate to fixer profile
        },
      ),
    ).then((_) {
      setState(() {
        _selectedFixer = null;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final initialPosition = widget.posterLocation != null
        ? LatLng(widget.posterLocation!.latitude, widget.posterLocation!.longitude)
        : widget.fixers.isNotEmpty
            ? LatLng(widget.fixers.first.fixerData!.latitude, widget.fixers.first.fixerData!.longitude)
            : const LatLng(11.2588, 75.7804); // Kozhikode default

    return Scaffold(
      body: GoogleMap(
        onMapCreated: (GoogleMapController controller) {
          _mapController = controller;
        },
        initialCameraPosition: CameraPosition(
          target: initialPosition,
          zoom: 12,
        ),
        markers: _markers,
        myLocationEnabled: true,
        myLocationButtonEnabled: true,
        zoomControlsEnabled: false,
        mapToolbarEnabled: false,
        buildingsEnabled: true,
        compassEnabled: true,
        mapType: MapType.normal,
      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          // Custom zoom controls (optional)
          Container(
            margin: const EdgeInsets.only(bottom: 16),
            child: Column(
              children: [
                FloatingActionButton(
                  mini: true,
                  heroTag: "zoom_in",
                  backgroundColor: Colors.white,
                  foregroundColor: Colors.black87,
                  onPressed: () {
                    _mapController?.animateCamera(
                      CameraUpdate.zoomIn(),
                    );
                  },
                  child: const Icon(Icons.add),
                ),
                const SizedBox(height: 8),
                FloatingActionButton(
                  mini: true,
                  heroTag: "zoom_out",
                  backgroundColor: Colors.white,
                  foregroundColor: Colors.black87,
                  onPressed: () {
                    _mapController?.animateCamera(
                      CameraUpdate.zoomOut(),
                    );
                  },
                  child: const Icon(Icons.remove),
                ),
              ],
            ),
          ),
          // Back button
          FloatingActionButton(
            heroTag: "back_button",
            backgroundColor: Colors.white,
            foregroundColor: Colors.black87,
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Icon(Icons.arrow_back),
          ),
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }

  @override
  void dispose() {
    _mapController?.dispose();
    super.dispose();
  }
}

// Alternative approach if you want to keep it as a widget (not full screen page)
class PosterExploreMapViewWidget extends StatefulWidget {
  final List<UserProfileModel> fixers;
  final Position? posterLocation;

  const PosterExploreMapViewWidget({
    super.key,
    required this.fixers,
    required this.posterLocation,
  });

  @override
  State<PosterExploreMapViewWidget> createState() => _PosterExploreMapViewWidgetState();
}

class _PosterExploreMapViewWidgetState extends State<PosterExploreMapViewWidget> {
  GoogleMapController? _mapController;
  Set<Marker> _markers = {};
  UserProfileModel? _selectedFixer;

  @override
  void initState() {
    super.initState();
    _createMarkers();
  }

  @override
  void didUpdateWidget(PosterExploreMapViewWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.fixers != widget.fixers) {
      _createMarkers();
    }
  }

  void _createMarkers() {
    final markers = <Marker>{};

    // Add poster location marker
    if (widget.posterLocation != null) {
      markers.add(
        Marker(
          markerId: const MarkerId('poster_location'),
          position: LatLng(
            widget.posterLocation!.latitude,
            widget.posterLocation!.longitude,
          ),
          icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
          infoWindow: const InfoWindow(
            title: 'Your Location',
            snippet: 'You are here',
          ),
        ),
      );
    }

    // Add fixer markers
    for (int i = 0; i < widget.fixers.length; i++) {
      final fixer = widget.fixers[i];
      if (fixer.fixerData?.latitude != null && 
          fixer.fixerData?.longitude != null &&
          fixer.fixerData!.latitude != 0.0 &&
          fixer.fixerData!.longitude != 0.0) {
        markers.add(
          Marker(
            markerId: MarkerId('fixer_${fixer.uid}'),
            position: LatLng(
              fixer.fixerData!.latitude,
              fixer.fixerData!.longitude,
            ),
            icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
            infoWindow: InfoWindow(
              title: fixer.name,
              snippet: fixer.fixerData?.skills?.take(2).join(', ') ?? '',
            ),
            onTap: () => _showFixerBottomSheet(fixer),
          ),
        );
      }
    }

    setState(() {
      _markers = markers;
    });
  }

  void _showFixerBottomSheet(UserProfileModel fixer) {
    setState(() {
      _selectedFixer = fixer;
    });

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => FixerBottomSheet(
        fixer: fixer,
        posterLocation: widget.posterLocation,
        onViewProfile: () {
          Navigator.pop(context);
          // Navigate to fixer profile
        },
      ),
    ).then((_) {
      setState(() {
        _selectedFixer = null;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final initialPosition = widget.posterLocation != null
        ? LatLng(widget.posterLocation!.latitude, widget.posterLocation!.longitude)
        : widget.fixers.isNotEmpty
            ? LatLng(widget.fixers.first.fixerData!.latitude, widget.fixers.first.fixerData!.longitude)
            : const LatLng(11.2588, 75.7804); // Kozhikode default

    return Stack(
      children: [
        // Full screen map
        GoogleMap(
          onMapCreated: (GoogleMapController controller) {
            _mapController = controller;
          },
          initialCameraPosition: CameraPosition(
            target: initialPosition,
            zoom: 12,
          ),
          markers: _markers,
          myLocationEnabled: true,
          myLocationButtonEnabled: false, // We'll add custom location button
          zoomControlsEnabled: false,
          mapToolbarEnabled: false,
          buildingsEnabled: true,
          compassEnabled: true,
          mapType: MapType.normal,
        ),
        
        // Custom controls overlay
        Positioned(
          top: MediaQuery.of(context).padding.top + 16,
          right: 16,
          child: Column(
            children: [
              // My Location Button
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: IconButton(
                  onPressed: () {
                    if (widget.posterLocation != null) {
                      _mapController?.animateCamera(
                        CameraUpdate.newLatLng(
                          LatLng(
                            widget.posterLocation!.latitude,
                            widget.posterLocation!.longitude,
                          ),
                        ),
                      );
                    }
                  },
                  icon: const Icon(Icons.my_location, color: AppColors.primary),
                ),
              ),
              const SizedBox(height: 8),
              
              // Zoom In Button
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: IconButton(
                  onPressed: () {
                    _mapController?.animateCamera(CameraUpdate.zoomIn());
                  },
                  icon: const Icon(Icons.add, color: Colors.black87),
                ),
              ),
              const SizedBox(height: 8),
              
              // Zoom Out Button
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: IconButton(
                  onPressed: () {
                    _mapController?.animateCamera(CameraUpdate.zoomOut());
                  },
                  icon: const Icon(Icons.remove, color: Colors.black87),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  @override
  void dispose() {
    _mapController?.dispose();
    super.dispose();
  }
}

// FixerBottomSheet remains the same
class FixerBottomSheet extends StatelessWidget {
  final UserProfileModel fixer;
  final Position? posterLocation;
  final VoidCallback onViewProfile;

  const FixerBottomSheet({
    super.key,
    required this.fixer,
    required this.posterLocation,
    required this.onViewProfile,
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
      return '${(distance * 1000).round()}m away';
    } else {
      return '${distance.toStringAsFixed(1)}km away';
    }
  }

  @override
  Widget build(BuildContext context) {
    final distance = _getDistance();
    
    return DraggableScrollableSheet(
      initialChildSize: 0.4,
      minChildSize: 0.3,
      maxChildSize: 0.8,
      builder: (context, scrollController) {
        return Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: Column(
            children: [
              // Handle bar
              Container(
                width: 40,
                height: 4,
                margin: const EdgeInsets.symmetric(vertical: 12),
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(2),
                ),
              ),

              Expanded(
                child: SingleChildScrollView(
                  controller: scrollController,
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Profile Header
                      Row(
                        children: [
                          // Profile Image
                          CircleAvatar(
                            radius: 30,
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
                                      fontSize: 24,
                                    ),
                                  )
                                : null,
                          ),
                          const SizedBox(width: 16),

                          // Name and Rating
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  fixer.name,
                                  style: const TextStyle(
                                    fontSize: 20,
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
                                          size: 18,
                                          color: Colors.amber,
                                        ),
                                        const SizedBox(width: 4),
                                        const Text(
                                          '4.8',
                                          style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                        const SizedBox(width: 4),
                                        Text(
                                          '(24 reviews)',
                                          style: TextStyle(
                                            fontSize: 14,
                                            color: Colors.grey[600],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                                if (distance.isNotEmpty) ...[
                                  const SizedBox(height: 4),
                                  Row(
                                    children: [
                                      Icon(
                                        Icons.location_on,
                                        size: 16,
                                        color: Colors.grey[500],
                                      ),
                                      const SizedBox(width: 4),
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
                          ),
                        ],
                      ),

                      const SizedBox(height: 20),

                      // Skills Section
                      if (fixer.fixerData?.skills != null && fixer.fixerData!.skills!.isNotEmpty) ...[
                        const Text(
                          'Skills',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: AppColors.primaryText,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: fixer.fixerData!.skills!.map((skill) {
                            return Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 6,
                              ),
                              decoration: BoxDecoration(
                                color: AppColors.primary.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(16),
                              ),
                              child: Text(
                                skill,
                                style: const TextStyle(
                                  color: AppColors.primary,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            );
                          }).toList(),
                        ),
                        const SizedBox(height: 20),
                      ],

                      // Bio Section
                      if (fixer.fixerData?.bio != null && fixer.fixerData!.bio.isNotEmpty) ...[
                        const Text(
                          'About',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: AppColors.primaryText,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          fixer.fixerData!.bio,
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[600],
                            height: 1.4,
                          ),
                        ),
                        const SizedBox(height: 20),
                      ],

                      // Recent Works Section
                      const Text(
                        'Recent Works',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: AppColors.primaryText,
                        ),
                      ),
                      const SizedBox(height: 12),

                      // Recent Works Grid
                      SizedBox(
                        height: 120,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: 3, // Mock data
                          itemBuilder: (context, index) {
                            return Container(
                              width: 140,
                              margin: const EdgeInsets.only(right: 12),
                              decoration: BoxDecoration(
                                color: Colors.grey[100],
                                borderRadius: BorderRadius.circular(12),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.06),
                                    blurRadius: 4,
                                    offset: const Offset(0, 2),
                                  ),
                                ],
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Expanded(
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color: Colors.grey[200],
                                        borderRadius: const BorderRadius.vertical(
                                          top: Radius.circular(12),
                                        ),
                                        image: const DecorationImage(
                                          image: NetworkImage(
                                            'https://via.placeholder.com/140x70',
                                          ),
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          index == 0 ? 'Kitchen Repair' : 
                                          index == 1 ? 'Electrical Work' : 'Plumbing Fix',
                                          style: const TextStyle(
                                            fontSize: 12,
                                            fontWeight: FontWeight.w600,
                                          ),
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                        const SizedBox(height: 2),
                                        Text(
                                          index == 0 ? '₹150' : 
                                          index == 1 ? '₹200' : '₹80',
                                          style: const TextStyle(
                                            fontSize: 12,
                                            color: AppColors.primary,
                                            fontWeight: FontWeight.w700,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                      ),

                      const SizedBox(height: 30),

                      // Action Buttons
                      Row(
                        children: [
                          Expanded(
                            child: OutlinedButton(
                              onPressed: () {
                                // Handle message action
                                Navigator.pop(context);
                              },
                              style: OutlinedButton.styleFrom(
                                side: const BorderSide(color: AppColors.primary),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                padding: const EdgeInsets.symmetric(vertical: 14),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Icon(
                                    Icons.message,
                                    size: 18,
                                    color: AppColors.primary,
                                  ),
                                  const SizedBox(width: 8),
                                  const Text(
                                    'Message',
                                    style: TextStyle(
                                      color: AppColors.primary,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: AppButton(
                              text: 'View Profile',
                              onPressed: onViewProfile,
                              height: 50,
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}