import 'dart:async';

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

// Future<void> switchRoleLocally() async {
//     emit(RoleSwitchLoading());
//     print("[RoleSwitch] Started LOCAL switching (workaround)");

//     try {
//       final uid = _auth.currentUser!.uid;
//       final userDoc = _firestore.collection('users').doc(uid);
//       final snapshot = await userDoc.get();

//       if (!snapshot.exists) throw Exception("User not found");

//       final currentRole = snapshot['activeRole'];
//       final newRole = currentRole == 'poster' ? 'fixer' : 'poster';
      
//       print("[RoleSwitch] LOCAL switch from $currentRole to $newRole");
      
//       // Skip Firebase update, just emit success for UI testing
//       await Future.delayed(const Duration(milliseconds: 500));
//       emit(RoleSwitchSuccess(newRole));
//       print("[RoleSwitch] LOCAL switch completed");
      
//     } catch (e) {
//       print("[RoleSwitch] LOCAL switch error: $e");
//       emit(RoleSwitchError(e.toString()));
//     }
//   }

  Future<void> switchRole() async {
  emit(RoleSwitchLoading());
 // print("[RoleSwitch] Started switching");

  try {
    final uid = _auth.currentUser!.uid;
  //  print("[RoleSwitch] Current user UID: $uid");
    
    final userDoc = _firestore.collection('users').doc(uid);
    final snapshot = await userDoc.get();
   // print("[RoleSwitch] User doc fetched");

    if (!snapshot.exists) throw Exception("User not found");

    final currentRole = snapshot['activeRole'];
  //  print("[RoleSwitch] Current role: $currentRole");
    
    final newRole = currentRole == 'poster' ? 'fixer' : 'poster';
    print("[RoleSwitch] New role will be: $newRole");
    
    final newRoleDoc = userDoc.collection('roles').doc(newRole);
    final docSnapshot = await newRoleDoc.get();
  //  print("[RoleSwitch] New role doc fetched: $newRole");
  //  print("[RoleSwitch] New role doc exists: ${docSnapshot.exists}");

    // Fixer profile check
    if (newRole == 'fixer') {
    //  print("[RoleSwitch] Checking fixer profile...");
      final fixerData = docSnapshot.data()?['fixerData'];
      print("[RoleSwitch] Fixer data: $fixerData");
      
      if (fixerData != null && fixerData['skills'] != null) {
        final skills = fixerData['skills'] as List;
        print("[RoleSwitch] Fixer skills: $skills");
    //    print("[RoleSwitch] Skills length: ${skills.length}");
        
        if (skills.isEmpty) {
     //     print("[RoleSwitch] Skills list is empty - incomplete profile");
          emit(RoleSwitchIncompleteProfile('fixer'));
          return;
        } else {
   //       print("[RoleSwitch] Fixer profile is complete");
        }
      } else {
    //    print("[RoleSwitch] Fixer data or skills is null - incomplete profile");
        emit(RoleSwitchIncompleteProfile('fixer'));
        return;
      }
    }

    // Poster role creation if not exists
    if (newRole == 'poster' && !docSnapshot.exists) {
   //   print("[RoleSwitch] Creating poster role doc...");
      await newRoleDoc.set({
        'uid': uid,
        'role': 'poster',
        'name': snapshot['name'] ?? '',
        'bio': '',
        'phone': '',
        'location': '',
      });
  //    print("[RoleSwitch] Poster role doc created");
    }

    // Switch role
  //  print("[RoleSwitch] Updating active role to: $newRole");
    
    // First, let's test if we can still read from Firebase
    try {
    //  print("[RoleSwitch] Testing Firebase connection by re-reading user doc...");
   //  final testRead = await userDoc.get().timeout(const Duration(seconds: 5));
   //   print("[RoleSwitch] Test read successful, doc exists: ${testRead.exists}");
    } catch (testError) {
  //    print("[RoleSwitch] Test read failed: $testError");
      throw Exception("Firebase connection lost: $testError");
    }
    
    // Force Firebase to go online
    try {
   //   print("[RoleSwitch] Enabling network and clearing cache...");
      await _firestore.enableNetwork();
      await _firestore.clearPersistence();
   //   print("[RoleSwitch] Network enabled and cache cleared");
    } catch (networkError) {
   //   print("[RoleSwitch] Network enable failed: $networkError");
      // Continue anyway
    }
    
    try {
      // Try using set with merge instead of update
   //   print("[RoleSwitch] Attempting set with merge instead of update...");
      await userDoc.set({'activeRole': newRole}, SetOptions(merge: true)).timeout(
        const Duration(seconds: 30), // Much longer timeout
        onTimeout: () {
          throw TimeoutException('Role set timed out after 30 seconds');
        },
      );
    //  print("[RoleSwitch] Role updated successfully to $newRole using set");
    } catch (updateError) {
    //  print("[RoleSwitch] Set operation failed: $updateError");
      
      // Even if it times out, the write might have succeeded
      // Let's check by reading the document again
   //   print("[RoleSwitch] Checking if write actually succeeded despite timeout...");
      try {
        await Future.delayed(const Duration(seconds: 2)); // Wait a bit
        final checkDoc = await userDoc.get();
        final actualRole = checkDoc['activeRole'];
      //  print("[RoleSwitch] Actual role in database: $actualRole");
     //   
        if (actualRole == newRole) {
       //   print("[RoleSwitch] Write succeeded despite timeout!");
          // Continue with success flow
        } else {
        //  print("[RoleSwitch] Write genuinely failed");
         rethrow; 
        }
      } catch (checkError) {
       // print("[RoleSwitch] Could not verify write success: $checkError");
        throw updateError;
      }
    }
    
    await Future.delayed(const Duration(milliseconds: 500));
   // print("[RoleSwitch] Delay completed, emitting success");
    
    emit(RoleSwitchSuccess(newRole));
   // print("[RoleSwitch] RoleSwitchSuccess emitted with role: $newRole");
  } catch (e) {
   // print("[RoleSwitch] ERROR occurred: $e");
  //  print("[RoleSwitch] Error type: ${e.runtimeType}");
    emit(RoleSwitchError(e.toString()));
  }
}
}
