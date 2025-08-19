// features/explore/poster/repository/poster_explore_repository.dart

import 'dart:async';
import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:geolocator/geolocator.dart';
import 'package:quick_pitch_app/core/services/firebase/skill/skills_service.dart';
import 'package:quick_pitch_app/features/profile_completion/model/user_profile_model.dart';

class PosterExploreRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final SkillService _skillService = SkillService();

  /// Fetch admin-configured skills from Firestore
  Future<List<String>> fetchAdminSkills() async {
    try {
      return await _skillService.fetchAllSkills();
    } catch (e) {
      throw Exception('Failed to fetch skills: $e');
    }
  }

  /// Fetch fixers with pagination support
Future<List<UserProfileModel>> fetchFixers() async {
  try {
    final usersSnapshot = await _firestore.collection('users').get();

    List<UserProfileModel> fixers = [];

    for (var userDoc in usersSnapshot.docs) {
      final fixerDoc = await userDoc.reference
          .collection('roles')
          .doc('fixer')
          .get();

      if (fixerDoc.exists) {
        fixers.add(UserProfileModel.fromJson(fixerDoc.data()!));
      }
    }

    return fixers;
  } catch (e) {
    throw Exception('Failed to fetch fixers: $e');
  }
}


  /// Get current position with fallback to last known position
  Future<Position?> getCurrentPositionWithFallback() async {
    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        // Try to get last known position
        return await Geolocator.getLastKnownPosition();
      }

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          return await Geolocator.getLastKnownPosition();
        }
      }

      if (permission == LocationPermission.deniedForever) {
        return await Geolocator.getLastKnownPosition();
      }

      return await Geolocator.getCurrentPosition(
        // ignore: deprecated_member_use
        desiredAccuracy: LocationAccuracy.medium,
        // ignore: deprecated_member_use
        timeLimit: const Duration(seconds: 10),
      ).timeout(
        const Duration(seconds: 15),
        onTimeout: () async {
          final lastKnown = await Geolocator.getLastKnownPosition();
          // If lastKnown is null, throw a TimeoutException to match the expected type
          if (lastKnown == null) {
            throw TimeoutException('Location request timed out and no last known position available');
          }
          return lastKnown;
        },
      );
    } catch (e) {
      // Return last known position as fallback
      return await Geolocator.getLastKnownPosition();
    }
  }

  /// Calculate distance between two points using Haversine formula
  /// Returns distance in kilometers
  static double haversineKm(double lat1, double lon1, double lat2, double lon2) {
    const double earthRadiusKm = 6371.0;
    
    final double dLat = _degreesToRadians(lat2 - lat1);
    final double dLon = _degreesToRadians(lon2 - lon1);
    
    final double a = sin(dLat / 2) * sin(dLat / 2) +
        cos(_degreesToRadians(lat1)) * cos(_degreesToRadians(lat2)) *
        sin(dLon / 2) * sin(dLon / 2);
    
    final double c = 2 * atan2(sqrt(a), sqrt(1 - a));
    
    return earthRadiusKm * c;
  }

  static double _degreesToRadians(double degrees) {
    return degrees * pi / 180;
  }
}
