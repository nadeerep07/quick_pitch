import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';
import 'package:quick_pitch_app/core/services/cloudninary/cloudinary_services.dart';
import 'package:quick_pitch_app/features/profile_completion/model/user_profile_model.dart';
import 'package:geocoding/geocoding.dart' as geo;


class FixerProfileEditingRespository {

 final FirebaseFirestore _firestore = FirebaseFirestore.instance;
final String? uid = FirebaseAuth.instance.currentUser?.uid;

Future<UserProfileModel> getProfileData() async {
  if (uid == null) throw Exception("User not logged in");
  final doc = await _firestore
      .collection('users')
      .doc(uid)
      .collection('roles')
      .doc('fixer')
      .get();

  if (!doc.exists) throw Exception("Profile not found");

  return UserProfileModel.fromJson(doc.data()!);
}


  Future<List<String>> getAvailableSkills() async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) throw Exception("Fixer not logged in");

    final fixerRoleDoc = await FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .collection('roles')
        .doc('fixer')
        .get();

    if (!fixerRoleDoc.exists) throw Exception("Fixer role data not found");
final data = fixerRoleDoc.data();

    final fixerSkillCategories =
    List<String>.from(data?['fixerData']?['skills'] ?? []);
    print(fixerSkillCategories);
    return fixerSkillCategories;
  }


Future<File?> pickImage() async {
  final picked = await ImagePicker().pickImage(source: ImageSource.gallery);
  return picked != null ? File(picked.path) : null;
}




Future<String> getCurrentLocation() async {
  bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
  if (!serviceEnabled) throw Exception('Location services are disabled.');

  LocationPermission permission = await Geolocator.checkPermission();
  if (permission == LocationPermission.denied) {
    permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.deniedForever) {
      throw Exception('Location permission permanently denied.');
    }
  }

  final position = await Geolocator.getCurrentPosition();
  final placemark = await geo.placemarkFromCoordinates(position.latitude, position.longitude);
  if (placemark.isEmpty) return 'Unable to fetch address';
    final place = placemark.first;
    final locationText =
        '${place.locality}, ${place.administrativeArea}, ${place.country}';
  return  locationText;
}
Future<void> updateProfileImageWithCloudinary(File imageFile) async {
  if (uid == null) throw Exception("User not logged in");

  try {
    final cloudinaryService = CloudinaryService();
    final imageUrl = await cloudinaryService.uploadFile(imageFile);

    await _firestore
        .collection('users')
        .doc(uid)
        .collection('roles')
        .doc('fixer')
        .update({
          'profileImageUrl': imageUrl,
        });
  } catch (e) {
    throw Exception("Cloudinary upload + Firestore update failed: $e");
  }
}
Future<void> updateCertificateImageWithCloudinary(File imageFile) async {
  if (uid == null) throw Exception("User not logged in");

  try {
    final cloudinaryService = CloudinaryService();
    final imageUrl = await cloudinaryService.uploadFile(imageFile);

    await _firestore
        .collection('users')
        .doc(uid)
        .collection('roles')
        .doc('fixer')
        .update({
          'fixerData.certificateImageUrl': imageUrl,
        });
  } catch (e) {
    throw Exception("Cloudinary cert upload failed: $e");
  }
}


Future<void> updateProfile({
  required String name,
  required String location,
  required String phone,
  required String bio,
  File? profileImage,
  File? certificateImage,
  required List<String> skills,
}) async {
  if (uid == null) throw Exception("User not logged in");

  try {
    final userDocRef = _firestore.collection('users').doc(uid);
    final fixerDocRef = userDocRef.collection('roles').doc('fixer');

    final cloudinaryService = CloudinaryService();
    String? profileImageUrl;
    String? certificateImageUrl;

    if (profileImage != null) {
      profileImageUrl = await cloudinaryService.uploadFile(profileImage);
    }

    if (certificateImage != null) {
      certificateImageUrl =
          await cloudinaryService.uploadFile(certificateImage);
    }

    // Prepare data to update
    Map<String, dynamic> updateData = {
      'uid': uid,
      'name': name,
      'phone': phone,
      'role': 'fixer',
      'location': location,
      'createdAt': FieldValue.serverTimestamp(),
      if (profileImageUrl != null) 'profileImageUrl': profileImageUrl,
      'fixerData': {
        'bio': bio,
        'skills': skills,
        if (certificateImageUrl != null)
          'certificateImageUrl': certificateImageUrl,
      },
    };

    await fixerDocRef.update(updateData);
  } catch (e) {
    throw Exception("Profile update failed: $e");
  }
}


}
