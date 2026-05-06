
import 'package:cloud_firestore/cloud_firestore.dart';

class Task {
  final String id;
  final String title;
  final String userId;
  final bool isCompleted;
  final Timestamp createdAt;

  Task({
    required this.id,
    required this.title,
    required this.userId,
    this.isCompleted = false,
    required this.createdAt,
  });

  // Convert a Task object into a map for Firestore
  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'userId': userId,
      'isCompleted': isCompleted,
      'createdAt': createdAt,
    };
  }

  // Create a Task object from a Firestore document
  factory Task.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return Task(
      id: doc.id,
      title: data['title'] ?? '',
      userId: data['userId'] ?? '',
      isCompleted: data['isCompleted'] ?? false,
      createdAt: data['createdAt'] ?? Timestamp.now(),
    );
  }
}
