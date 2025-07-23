import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:image_picker/image_picker.dart';
import 'package:quick_pitch_app/core/services/cloudninary/cloudinary_services.dart';

class FixerProfileRepository {
  final ImagePicker _picker = ImagePicker();
  final CloudinaryService _cloudinaryService = CloudinaryService();

  Future<String?> pickAndUploadCoverImage() async {
    try {
      final XFile? pickedFile = await _picker.pickImage(
        source: ImageSource.gallery,
      );

      if (pickedFile == null) return null;

      final File file = File(pickedFile.path);

      final String imageUrl = await _cloudinaryService.uploadFile(file);
      return imageUrl;
    } catch (e) {
      print('❌ Error while picking/uploading cover image: $e');
      return null;
    }
  }

  Future<void> removeCoverImageFromFirestore() async {
    try {
      final userId = FirebaseAuth.instance.currentUser?.uid;
      if (userId == null) throw Exception("User not logged in");

      await FirebaseFirestore.instance.collection('users').doc(userId).collection('roles').doc('fixer').update({
        'fixerData.coverImageUrl': FieldValue.delete(),
      });
    } catch (e) {
      print('❌ Error while removing cover image: $e');
      rethrow;
    }
  }

  Future<String?> pickAndUploadProfileImage() async {
  try {
    final XFile? pickedFile = await _picker.pickImage(
      source: ImageSource.gallery,
    );

    if (pickedFile == null) return null;

    final File file = File(pickedFile.path);

    final String imageUrl = await _cloudinaryService.uploadFile(file);

    // Upload to Firestore under the fixer's profile
    final userId = FirebaseAuth.instance.currentUser?.uid;
    if (userId == null) throw Exception("User not logged in");

    await FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .update({
      'profileImageUrl': imageUrl,
    });

    return imageUrl;
  } catch (e) {
    print(' Error while picking/uploading profile image: $e');
    return null;
  }
}
 
}
