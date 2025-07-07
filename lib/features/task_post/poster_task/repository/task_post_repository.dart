import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:quick_pitch_app/features/task_post/poster_task/model/task_post_model.dart';

class TaskPostRepository {
  final CollectionReference _collection = FirebaseFirestore.instance.collection(
    "poster_tasks",
  );

  Future<void> postTask(TaskPostModel taskData) async {
     final docRef = _collection.doc(taskData.id);
  await docRef.set(taskData.toMap());
  print(" Task posted to: ${docRef.path}");
  }

  Future<List<TaskPostModel>> getUserTasks(String userId) async {
    final query = await _collection.where("posterId", isEqualTo: userId).get();
    return query.docs
        .map((doc) => TaskPostModel.fromMap(doc.data() as Map<String, dynamic>))
        .toList();
  }
}
