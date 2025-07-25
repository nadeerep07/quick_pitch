import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
// ignore: depend_on_referenced_packages
import 'package:meta/meta.dart';

part 'role_switch_state.dart';

class RoleSwitchCubit extends Cubit<RoleSwitchState> {
  RoleSwitchCubit() : super(RoleSwitchInitial());

  final _firestore = FirebaseFirestore.instance;
  final _auth = FirebaseAuth.instance;

  Future<void> switchRole() async {
    emit(RoleSwitchLoading());
    print("[RoleSwitch] Started switching");

    try {
      final uid = _auth.currentUser!.uid;
      final userDoc = _firestore.collection('users').doc(uid);
      final snapshot = await userDoc.get();
      // print("[RoleSwitch] User doc fetched");

      if (!snapshot.exists) throw Exception("User not found");

      final currentRole = snapshot['activeRole'];
      final newRole = currentRole == 'poster' ? 'fixer' : 'poster';
      final newRoleDoc = userDoc.collection('roles').doc(newRole);

      final docSnapshot = await newRoleDoc.get();
      // print("[RoleSwitch] New role doc fetched: $newRole");

      // Fixer profile check
      if (newRole == 'fixer') {
        final fixerData = docSnapshot.data()?['fixerData'];
        // print("[RoleSwitch] Fixer data: $fixerData");
        // print('[RoleSwitch] Fixer data: ${fixerData['skills']}');

        if (fixerData == null ||
            fixerData['skills'] == null ||
            (fixerData['skills'] as List).isEmpty) {
          // print("[RoleSwitch] Incomplete fixer profile");
          emit(RoleSwitchIncompleteProfile('fixer'));
          return;
        }
      }

      // Poster role creation if not exists
      if (newRole == 'poster' && !docSnapshot.exists) {
        // print("[RoleSwitch] Creating poster role doc...");
        await newRoleDoc.set({
          'uid': uid,
          'role': 'poster',
          'name': snapshot['name'] ?? '',
          'bio': '',
          'phone': '',
          'location': '',
        });
      }

      // Switch role
      await userDoc.update({'activeRole': newRole});
      print("[RoleSwitch] Role updated to $newRole");
      emit(RoleSwitchSuccess(newRole));
    } catch (e) {
      print("[RoleSwitch] ERROR: $e");
      emit(RoleSwitchError(e.toString()));
    }
  }
}
