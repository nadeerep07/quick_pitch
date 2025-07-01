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

      final currentRole = snapshot['role'];
      final newRole = currentRole == 'poster' ? 'fixer' : 'poster';

      await userDoc.update({'role': newRole});
      emit(RoleSwitchSuccess(newRole));
    } catch (e) {
      emit(RoleSwitchError(e.toString()));
    }
  }

}
