import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:quick_pitch_app/core/services/cloudninary/cloudinary_services.dart';
import 'package:quick_pitch_app/core/services/firebase/user_profile/user_profile_service.dart';
import 'package:quick_pitch_app/features/profile_completion/model/user_profile_model.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart' as geo;

class UserProfileRepository {
  final UserProfileService service = UserProfileService();
  final CloudinaryService _cloudinary = CloudinaryService();
    final FirebaseFirestore _db = FirebaseFirestore.instance;


  Future<void> saveProfile(UserProfileModel profile) async {
    await service.saveProfile(profile);
  }

 Future<void> updateProfile(UserProfileModel newProfile) async {
  final oldProfile = await service.getProfile(newProfile.uid, newProfile.role);
  final updatedFields = newProfile.toUpdatedFieldsMap(oldProfile!);

  if (updatedFields.isNotEmpty) {
    await service.updateFields(newProfile.uid, newProfile.role, updatedFields);
  }
}
Future<UserProfileModel?> getProfile(String uid, String role) async {
  return await service.getProfile(uid, role);
}



  Future<String> uploadFileToCloudinary(File file) async {
    return await _cloudinary.uploadFile(file);
  }

 Future<String> getCurrentLocation() async {
 // print("[DEBUG] Inside getCurrentLocation()");

  try {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) return 'Location services disabled';

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) return 'Permission denied';
    }

    Position? pos;
    try {
      pos = await Geolocator.getCurrentPosition(
        // ignore: deprecated_member_use
        desiredAccuracy: LocationAccuracy.low,
      ).timeout(
        const Duration(seconds: 8),
        onTimeout: () => throw Exception('Location timeout'),
      );
    } catch (e) {
  //    print('[DEBUG] Primary position fetch failed: $e');
      pos = await Geolocator.getLastKnownPosition();
      if (pos == null) return 'Unable to get current position';
    }

  //  print("[DEBUG] Current Position: ${pos.latitude}, ${pos.longitude}");

    final placemarks = await geo.placemarkFromCoordinates(
      pos.latitude,
      pos.longitude,
    );

  //  print("[DEBUG] Placemarks: $placemarks");

    if (placemarks.isEmpty) return 'Unable to fetch address';
    final place = placemarks.first;
    final locationText =
        '${place.locality}, ${place.administrativeArea}, ${place.country}';
 //   print("[DEBUG] Final location: $locationText");

    return locationText;
  } catch (e) {
  //  print("[DEBUG] getCurrentLocation error: $e");
    return 'Location error: ${e.toString()}';
  }
}
  Future<List<String>> fetchSkillsFromAdmin() async {
    final snapshot = await _db.collection('skills').orderBy('name').get();
    return snapshot.docs.map((doc) => doc['name'].toString()).toList();
  }
Future<List<String>> getFixerSkills(String userId) async {
  final doc = await _db.collection('users').doc(userId).get();
  if (doc.exists) {
    final data = doc.data();
    if (data != null && data['skills'] != null) {
      return List<String>.from(data['skills']);
    }
  }
  return [];
}

}
