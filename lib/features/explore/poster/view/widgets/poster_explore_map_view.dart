import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:quick_pitch_app/core/config/responsive.dart';
import 'package:quick_pitch_app/features/explore/poster/view/widgets/custome_mark_painter.dart';
import 'package:quick_pitch_app/features/explore/poster/view/widgets/fixer_bottom_sheet/fixer-detail_bottom_sheet.dart';
import 'package:quick_pitch_app/features/profile_completion/model/user_profile_model.dart';

class PosterExploreMapView extends StatefulWidget {
  final List<UserProfileModel> fixers;
  final Position? posterLocation;

  const PosterExploreMapView({
    super.key,
    required this.fixers,
    this.posterLocation,
  });

  @override
  State<PosterExploreMapView> createState() => _PosterExploreMapViewState();
}

class _PosterExploreMapViewState extends State<PosterExploreMapView> {
  GoogleMapController? _controller;
  Set<Marker> _markers = {};
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadMarkers();
  }

  @override
  void didUpdateWidget(PosterExploreMapView oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.fixers != widget.fixers) {
      _loadMarkers();
    }
  }

  Future<void> _loadMarkers() async {
    setState(() {
      _isLoading = true;
    });

    final Set<Marker> markers = {};

    // Add user location marker if available
    if (widget.posterLocation != null) {
      markers.add(
        Marker(
          markerId: const MarkerId('user_location'),
          position: LatLng(
            widget.posterLocation!.latitude,
            widget.posterLocation!.longitude,
          ),
          infoWindow: const InfoWindow(
            title: 'Your Location',
          ),
          icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
        ),
      );
    }

    // Add fixer markers
    for (final fixer in widget.fixers) {
      if (fixer.fixerData?.latitude != null && 
          fixer.fixerData?.longitude != null &&
          fixer.fixerData!.latitude != 0.0 && 
          fixer.fixerData!.longitude != 0.0) {
        
        final certificateColor = MarkerGenerator.getCertificateStatusColor(
          fixer.fixerData?.certificateStatus,
        );

        final customMarker = await MarkerGenerator.createCustomMarker(
          fixer: fixer,
          certificateColor: certificateColor,
        );

        markers.add(
          Marker(
            markerId: MarkerId('fixer_${fixer.uid}'),
            position: LatLng(
              fixer.fixerData!.latitude,
              fixer.fixerData!.longitude,
            ),
            icon: customMarker,
            onTap: () => _showFixerDetails(fixer),
          ),
        );
      }
    }

    setState(() {
      _markers = markers;
      _isLoading = false;
    });
  }

  void _showFixerDetails(UserProfileModel fixer) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => FixerDetailsBottomSheet(
        fixer: fixer,
        posterLocation: widget.posterLocation,
      ),
    );
  }

  LatLng _getInitialCameraPosition() {
    if (widget.posterLocation != null) {
      return LatLng(
        widget.posterLocation!.latitude,
        widget.posterLocation!.longitude,
      );
    }
    
    // Default to Mumbai if no location available
    return const LatLng(19.0760, 72.8777);
  }

  void _onMapCreated(GoogleMapController controller) {
    _controller = controller;
    
    // Fit bounds to show all markers if there are multiple fixers
    if (widget.fixers.isNotEmpty && widget.posterLocation != null) {
      _fitBoundsToMarkers();
    }
  }

  void _fitBoundsToMarkers() {
    if (_controller == null || widget.fixers.isEmpty) return;

    final bounds = _calculateBounds();
    if (bounds != null) {
      _controller!.animateCamera(
        CameraUpdate.newLatLngBounds(bounds, 100.0),
      );
    }
  }

  LatLngBounds? _calculateBounds() {
    if (widget.fixers.isEmpty) return null;

    double minLat = double.infinity;
    double maxLat = -double.infinity;
    double minLng = double.infinity;
    double maxLng = -double.infinity;

    // Include user location if available
    if (widget.posterLocation != null) {
      minLat = widget.posterLocation!.latitude;
      maxLat = widget.posterLocation!.latitude;
      minLng = widget.posterLocation!.longitude;
      maxLng = widget.posterLocation!.longitude;
    }

    // Include all fixer locations
    for (final fixer in widget.fixers) {
      if (fixer.fixerData?.latitude != null && 
          fixer.fixerData?.longitude != null &&
          fixer.fixerData!.latitude != 0.0 && 
          fixer.fixerData!.longitude != 0.0) {
        
        final lat = fixer.fixerData!.latitude;
        final lng = fixer.fixerData!.longitude;

        minLat = minLat == double.infinity ? lat : (lat < minLat ? lat : minLat);
        maxLat = maxLat == -double.infinity ? lat : (lat > maxLat ? lat : maxLat);
        minLng = minLng == double.infinity ? lng : (lng < minLng ? lng : minLng);
        maxLng = maxLng == -double.infinity ? lng : (lng > maxLng ? lng : maxLng);
      }
    }

    if (minLat == double.infinity) return null;

    return LatLngBounds(
      southwest: LatLng(minLat, minLng),
      northeast: LatLng(maxLat, maxLng),
    );
  }

  @override
  Widget build(BuildContext context) {
    final res = Responsive(context);

    return Stack(
      children: [
        GoogleMap(
          onMapCreated: _onMapCreated,
          initialCameraPosition: CameraPosition(
            target: _getInitialCameraPosition(),
            zoom: 12.0,
          ),
          markers: _markers,
          myLocationEnabled: true,
          myLocationButtonEnabled: true,
          compassEnabled: true,
          mapToolbarEnabled: false,
          zoomControlsEnabled: false,
          mapType: MapType.normal,
        ),
        
        // Loading overlay
        if (_isLoading)
          Container(
            color: Colors.black26,
            child: const Center(
              child: CircularProgressIndicator(),
            ),
          ),
        
        // Fixer count badge
        Positioned(
          top: res.hp(2),
          right: res.wp(4),
          child: Container(
            padding: EdgeInsets.symmetric(
              horizontal: res.wp(3),
              vertical: res.hp(1),
            ),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 10,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.location_on,
                  size: res.sp(16),
                  color: Colors.blue,
                ),
                SizedBox(width: res.wp(1)),
                Text(
                  '${widget.fixers.length}',
                  style: TextStyle(
                    fontSize: res.sp(14),
                    fontWeight: FontWeight.bold,
                    color: Colors.blue,
                  ),
                ),
              ],
            ),
          ),
        ),
        
        // Recenter button
        Positioned(
          bottom: res.hp(12),
          right: res.wp(4),
          child: FloatingActionButton(
            mini: true,
            backgroundColor: Colors.white,
            onPressed: () {
              if (widget.posterLocation != null && _controller != null) {
                _controller!.animateCamera(
                  CameraUpdate.newLatLng(
                    LatLng(
                      widget.posterLocation!.latitude,
                      widget.posterLocation!.longitude,
                    ),
                  ),
                );
              }
            },
            child: Icon(
              Icons.my_location,
              color: Colors.blue,
              size: res.sp(20),
            ),
          ),
        ),
      ],
    );
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }
}