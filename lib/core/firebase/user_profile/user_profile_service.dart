// user_profile_service.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:quick_pitch_app/features/profile_completion/model/user_profile_model.dart';

class UserProfileService {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  Future<void> saveProfile(UserProfileModel profile) async {
    await firestore.collection('users').doc(profile.uid).set(profile.toJson(),SetOptions(merge: true));
  }

  Future<UserProfileModel?> getProfile(String uid) async {
    final doc = await firestore.collection('users').doc(uid).get();
    if (!doc.exists) return null;

    final data = doc.data()!;
    return UserProfileModel.fromJson(data);

  }
}
