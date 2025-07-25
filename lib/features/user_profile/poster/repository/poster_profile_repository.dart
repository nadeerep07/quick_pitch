import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:quick_pitch_app/features/profile_completion/model/user_profile_model.dart';

import 'package:quick_pitch_app/features/user_profile/fixer/repository/fixer_profile_repository.dart';

class PosterProfileRepository extends FixerProfileRepository {
   final FirebaseFirestore _firestore = FirebaseFirestore.instance;
final String? uid = FirebaseAuth.instance.currentUser?.uid;
  @override
  Future<void> removeCoverImageFromFirestore() async {
    try {
      final userId = FirebaseAuth.instance.currentUser?.uid;
      if (userId == null) throw Exception("User not logged in");

      await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .collection('roles')
          .doc('poster')
          .update({'posterData.coverImageUrl': FieldValue.delete()});
    } catch (e) {
    //  print('❌ Error while removing cover image: $e');
      rethrow;
    }
  }
  Future<UserProfileModel> getProfileData() async {
  if (uid == null) throw Exception("User not logged in");
  final doc = await _firestore
      .collection('users')
      .doc(uid)
      .collection('roles')
      .doc('poster')
      .get();

  if (!doc.exists) throw Exception("Profile not found");

  return UserProfileModel.fromJson(doc.data()!);
}
}
