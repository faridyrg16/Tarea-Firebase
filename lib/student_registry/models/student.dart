
import 'package:cloud_firestore/cloud_firestore.dart';

class Student {
  final String id;
  final String name;
  final int age;
  final String course;

  Student({
    required this.id,
    required this.name,
    required this.age,
    required this.course,
  });

  // Convert a Student object into a map for Firestore
  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'age': age,
      'course': course,
    };
  }

  // Create a Student object from a Firestore document
  factory Student.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return Student(
      id: doc.id,
      name: data['name'] ?? '',
      age: data['age'] ?? 0,
      course: data['course'] ?? '',
    );
  }
}
