import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:quick_pitch_app/features/poster_task/model/task_post_model.dart';

class TaskPostRepository {
  final CollectionReference _collection = FirebaseFirestore.instance.collection(
    "poster_tasks",
  );

  Future<void> postTask(TaskPostModel taskData) async {
     final docRef = _collection.doc(taskData.id);
  await docRef.set(taskData.toMap());
  //print(" Task posted to: ${docRef.path}");
  }

  Future<List<TaskPostModel>> getUserTasks(String userId) async {
    final query = await _collection.where("posterId", isEqualTo: userId).get();
    return query.docs
        .map((doc) => TaskPostModel.fromMap(doc.data() as Map<String, dynamic>))
        .toList();
  }
  Future<void> updateTask(TaskPostModel task) async {
  final docRef = FirebaseFirestore.instance.collection('poster_tasks').doc(task.id);
  await docRef.update(task.toMap());
  //print("Task updated at: ${docRef.path}");
  
}
Future<TaskPostModel?> getTaskById(String id) async {
  final doc = await _collection.doc(id).get();
  if (doc.exists) {
    return TaskPostModel.fromMap(doc.data() as Map<String, dynamic>);
  }
  return null;
}

Future<void> deleteTask(String taskId) async {
  await FirebaseFirestore.instance.collection('poster_tasks').doc(taskId).delete();
  
}

  Stream<List<TaskPostModel>> getPendingTasks() {
    return _collection
        .where('status', isEqualTo: 'pending')
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => TaskPostModel.fromMap(doc.data() as Map<String, dynamic>))
            .toList());
  }
  Future<List<TaskPostModel>> fetchAllTasks() async {
  try {
    final snapshot = await FirebaseFirestore.instance
        .collection('poster_tasks')
        .get();

    return snapshot.docs.map((doc) {
      return TaskPostModel.fromMap(doc.data());
    }).toList();
  } catch (e) {
  //  print('Error fetching tasks: $e');
    return [];
  }
}

}
