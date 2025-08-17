import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:image_picker/image_picker.dart';
import 'package:quick_pitch_app/core/services/cloudninary/cloudinary_services.dart';

class FixerProfileRepository {
  final ImagePicker _picker = ImagePicker();
  final CloudinaryService _cloudinaryService = CloudinaryService();

  /// Pick & upload cover image
  Future<String?> pickAndUploadCoverImage() async {
    return _pickAndUploadImage();
  }

  /// Pick & upload certificate
  Future<String?> pickAndUploadCertificate() async {
    return _pickAndUploadImage();
  }

  /// Internal reusable method for picking & uploading an image
  Future<String?> _pickAndUploadImage() async {
    try {
      final XFile? pickedFile = await _picker.pickImage(source: ImageSource.gallery);
      if (pickedFile == null) return null;

      final File file = File(pickedFile.path);
      final String imageUrl = await _cloudinaryService.uploadFile(file);
      return imageUrl;
    } catch (e) {
      // print('❌ Error while picking/uploading image: $e');
      return null;
    }
  }

  /// Remove cover image from Firestore
  Future<void> removeCoverImageFromFirestore() async {
    await _removeFirestoreField('fixerData.coverImageUrl');
  }

  /// Remove certificate from Firestore
  Future<void> removeCertificateFromFirestore() async {
    await _removeFirestoreField('fixerData.certification');
  }

  /// Internal reusable Firestore field removal
  Future<void> _removeFirestoreField(String fieldPath) async {
    try {
      final userId = FirebaseAuth.instance.currentUser?.uid;
      if (userId == null) throw Exception("User not logged in");

      await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .collection('roles')
          .doc('fixer')
          .update({fieldPath: FieldValue.delete()});
    } catch (e) {
      // print('❌ Error while removing field $fieldPath: $e');
      rethrow;
    }
  }
}
