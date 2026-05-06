
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/student.dart';

class StudentFirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final String _collectionPath = 'students';

  // Stream of all students
  Stream<List<Student>> getStudents() {
    return _db
        .collection(_collectionPath)
        .orderBy('name')
        .snapshots()
        .map((snapshot) => snapshot.docs.map((doc) => Student.fromFirestore(doc)).toList());
  }

  // Add a new student
  Future<void> addStudent(String name, int age, String course) {
    return _db.collection(_collectionPath).add({
      'name': name,
      'age': age,
      'course': course,
    });
  }

  // Update an existing student
  Future<void> updateStudent(String studentId, String name, int age, String course) {
    return _db.collection(_collectionPath).doc(studentId).update({
      'name': name,
      'age': age,
      'course': course,
    });
  }

  // Delete a student
  Future<void> deleteStudent(String studentId) {
    return _db.collection(_collectionPath).doc(studentId).delete();
  }
}
