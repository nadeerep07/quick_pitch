// fixer_explore_repository.dart

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:quick_pitch_app/features/poster_task/model/task_post_model.dart';

abstract class FixerExploreRepository {
  Future<List<TaskPostModel>> fetchCategoryMatchedTasks();
}

class FixerExploreRepositoryImpl implements FixerExploreRepository {
  @override
   Future<List<TaskPostModel>> fetchCategoryMatchedTasks() async {
  try {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) throw Exception("Fixer not logged in");

    final fixerRoleDoc = await FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .collection('roles')
        .doc('fixer')
        .get();

    if (!fixerRoleDoc.exists) throw Exception("Fixer role data not found");
    
    final data = fixerRoleDoc.data();
    final fixerSkillCategories = List<String>.from(data?['fixerData']?['skills'] ?? []);

    // Get ALL unassigned pending tasks first
    final tasksSnapshot = await FirebaseFirestore.instance
        .collection('poster_tasks')
        .where('assignedFixerId', isEqualTo: null)
        .where('status', isEqualTo: 'pending')
        .orderBy('createdAt', descending: true)
        .get();

  //  debugPrint('Total tasks fetched from Firestore: ${tasksSnapshot.docs.length}');

    final allTasks = tasksSnapshot.docs
        .map((doc) => TaskPostModel.fromMap(doc.data()))
        .toList();

    // Only apply skill filter if fixer has skills
    if (fixerSkillCategories.isEmpty) {
  //    debugPrint('No skills specified - returning all ${allTasks.length} tasks');
      return allTasks;
    }

    final filtered = allTasks.where((task) {
      final taskSkills = task.skills.map((s) => s.toLowerCase().trim()).toSet();
      final fixerSkills = fixerSkillCategories.map((s) => s.toLowerCase().trim()).toSet();
      return taskSkills.intersection(fixerSkills).isNotEmpty;
    }).toList();

   // debugPrint('After skill matching: ${filtered.length} tasks');
    return filtered;
  } catch (e) {
  //  debugPrint('Error fetching tasks: $e');
    rethrow;
  }
}
}