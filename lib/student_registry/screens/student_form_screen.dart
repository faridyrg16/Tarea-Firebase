
import 'package:flutter/material.dart';
import '../models/student.dart';
import '../services/student_firestore_service.dart';

class StudentFormScreen extends StatefulWidget {
  final Student? student;

  const StudentFormScreen({super.key, this.student});

  @override
  StudentFormScreenState createState() => StudentFormScreenState();
}

class StudentFormScreenState extends State<StudentFormScreen> {
  final formKey = GlobalKey<FormState>();
  final studentService = StudentFirestoreService();

  late String name;
  late int age;
  late String course;

  @override
  void initState() {
    super.initState();
    name = widget.student?.name ?? '';
    age = widget.student?.age ?? 0;
    course = widget.student?.course ?? '';
  }

  void saveForm() {
    final isValid = formKey.currentState!.validate();
    if (!isValid) {
      return;
    }
    formKey.currentState!.save();

    if (widget.student == null) {
      // Add new student
      studentService.addStudent(name, age, course);
    } else {
      // Update existing student
      studentService.updateStudent(widget.student!.id, name, age, course);
    }

    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.student == null ? 'Add Student' : 'Edit Student'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: formKey,
          child: Column(
            children: <Widget>[
              TextFormField(
                initialValue: name,
                decoration: const InputDecoration(labelText: 'Name'),
                validator: (value) =>
                    value!.isEmpty ? 'Please enter a name.' : null,
                onSaved: (value) => name = value!,
              ),
              TextFormField(
                initialValue: age == 0 ? '' : age.toString(),
                decoration: const InputDecoration(labelText: 'Age'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value!.isEmpty) return 'Please enter an age.';
                  if (int.tryParse(value) == null) return 'Please enter a valid number.';
                  if (int.parse(value) <= 0) return 'Please enter a positive age.';
                  return null;
                },
                onSaved: (value) => age = int.parse(value!),
              ),
              TextFormField(
                initialValue: course,
                decoration: const InputDecoration(labelText: 'Course'),
                validator: (value) =>
                    value!.isEmpty ? 'Please enter a course.' : null,
                onSaved: (value) => course = value!,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: saveForm,
                child: const Text('Save'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
