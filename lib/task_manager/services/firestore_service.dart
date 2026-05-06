
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../models/task.dart';

class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Get stream of tasks for the current user
  Stream<List<Task>> getTasks() {
    final user = _auth.currentUser;
    if (user == null) return Stream.value([]);

    return _db
        .collection('tasks')
        .where('userId', isEqualTo: user.uid)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs.map((doc) => Task.fromFirestore(doc)).toList());
  }

  // Add a new task
  Future<void> addTask(String title) {
    final user = _auth.currentUser;
    if (user == null) return Future.error('User not logged in');

    return _db.collection('tasks').add({
      'title': title,
      'userId': user.uid,
      'isCompleted': false,
      'createdAt': Timestamp.now(),
    });
  }

  // Update a task's completion status
  Future<void> updateTask(String taskId, bool isCompleted) {
    return _db.collection('tasks').doc(taskId).update({'isCompleted': isCompleted});
  }

  // Delete a task
  Future<void> deleteTask(String taskId) {
    return _db.collection('tasks').doc(taskId).delete();
  }
}
