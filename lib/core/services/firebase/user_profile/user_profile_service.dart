// user_profile_service.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:quick_pitch_app/features/profile_completion/model/user_profile_model.dart';

class UserProfileService {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  Future<void> saveProfile(UserProfileModel profile) async {
    await firestore
        .collection('users')
        .doc(profile.uid)
        .collection('roles')
        .doc(profile.role) // either 'fixer' or 'poster'
        .set(profile.toRoleJson(), SetOptions(merge: true));

    await firestore.collection('users').doc(profile.uid).set({
      'activeRole': profile.role,
      'name': profile.name,
      'uid': profile.uid,
    }, SetOptions(merge: true));
  }
 Future<void> updateProfile(UserProfileModel newProfile, UserProfileModel oldProfile) async {
  final updatedFields = newProfile.toUpdatedFieldsMap(oldProfile); 

  if (updatedFields.isNotEmpty) {
    await firestore
        .collection('users')
        .doc(newProfile.uid)
        .collection('roles')
        .doc(newProfile.role)
        .update(updatedFields); 
  }
}


  /// Get role-specific profile
  Future<UserProfileModel?> getProfile(String uid, String role) async {
    final doc =
        await firestore
            .collection('users')
            .doc(uid)
            .collection('roles')
            .doc(role)
            .get();

    if (!doc.exists) return null;

    final data = doc.data()!;
    return UserProfileModel.fromJson(data);
  }
Future<void> updateFields(String uid, String role, Map<String, dynamic> fieldsToUpdate) async {
  await FirebaseFirestore.instance
      .collection('users')
      .doc(uid)
      .collection('roles')
      .doc(role)
      .update(fieldsToUpdate);
}

}
