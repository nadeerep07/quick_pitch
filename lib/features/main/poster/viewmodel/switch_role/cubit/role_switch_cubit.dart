import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:meta/meta.dart';

part 'role_switch_state.dart';

class RoleSwitchCubit extends Cubit<RoleSwitchState> {
  RoleSwitchCubit() : super(RoleSwitchInitial());

  final _firestore = FirebaseFirestore.instance;
  final _auth = FirebaseAuth.instance;

  Future<void> switchRole() async {
    emit(RoleSwitchLoading());

      try {
    final uid = _auth.currentUser!.uid;
    final userDoc = _firestore.collection('users').doc(uid);
    final snapshot = await userDoc.get();

    if (!snapshot.exists) throw Exception("User not found");

    final currentRole = snapshot['activeRole'];
    final newRole = currentRole == 'poster' ? 'fixer' : 'poster';
    final newRoleDoc = userDoc.collection('roles').doc(newRole);

    final docSnapshot = await newRoleDoc.get();

   
    if (newRole == 'fixer') {
      final fixerData = docSnapshot.data()?['fixerData'];

      if (fixerData == null ||
          fixerData['skills'] == null ||
          (fixerData['skills'] as List).isEmpty) {
        emit(RoleSwitchIncompleteProfile('fixer'));
        return;
      }
    }

   
    if (newRole == 'poster' && !docSnapshot.exists) {
      await newRoleDoc.set({
        'uid': uid,
        'role': 'poster',
        'posterData': {'totalPosts': 0},
        'name': snapshot['name'] ?? '',
        'profileImageUrl': snapshot['profileImageUrl'] ?? '',
        'bio': '',
        'phone': '',
        'location': '',
      });
    }

    // 🟢 Switch role
    await userDoc.update({'activeRole': newRole});
    emit(RoleSwitchSuccess(newRole));
    } catch (e) {
      emit(RoleSwitchError(e.toString()));
    }
  }

}
