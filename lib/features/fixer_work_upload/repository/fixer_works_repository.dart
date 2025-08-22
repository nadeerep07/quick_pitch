import 'dart:async';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:quick_pitch_app/core/services/cloudninary/cloudinary_services.dart';
import 'package:quick_pitch_app/features/fixer_work_upload/model/fixer_work_upload_model.dart';

class FixerWorksRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;
  final CloudinaryService _cloudinary = CloudinaryService();
  final ImagePicker _imagePicker = ImagePicker();

  static const String _collectionName = 'fixer_works';

  // Fetch works for a specific fixer
  Stream<List<FixerWork>> getFixerWorks(String fixerId) {
    return _firestore
        .collection(_collectionName)
        .where('fixerId', isEqualTo: fixerId)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map(
          (snapshot) =>
              snapshot.docs.map((doc) => FixerWork.fromFirestore(doc)).toList(),
        );
  }

  // Add a new work
  Future<String> addWork(FixerWork work) async {
    final docRef = await _firestore
        .collection(_collectionName)
        .add(work.toFirestore());
    return docRef.id;
  }

  // Update existing work
  Future<void> updateWork(FixerWork work) async {
    await _firestore
        .collection(_collectionName)
        .doc(work.id)
        .update(work.toFirestore());
  }

  // Delete work
  Future<void> deleteWork(String workId) async {
    await _firestore.collection(_collectionName).doc(workId).delete();
  }

  // Pick images from gallery
  Future<List<XFile>> pickImages() async {
    final images = await _imagePicker.pickMultiImage(
      maxWidth: 1200,
      maxHeight: 1200,
      imageQuality: 80,
    );
    return images;
  }

  // Upload images to Firebase Storage
  Future<List<String>> uploadImages(List<XFile> imageFiles) async {
    final files = imageFiles.map((xfile) => File(xfile.path)).toList();

    // Parallel uploads instead of sequential
    final urls = await Future.wait(
      files.map((file) => _cloudinary.uploadFile(file)),
    );

    return urls;
  }

  // Delete images from storage
  Future<void> deleteImages(List<String> imageUrls) async {
    for (final url in imageUrls) {
      try {
        final ref = _storage.refFromURL(url);
        await ref.delete();
      } catch (e) {
        print('Error deleting image: $e');
      }
    }
  }
}
