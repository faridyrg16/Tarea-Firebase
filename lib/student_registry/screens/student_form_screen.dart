
import 'package:flutter/material.dart';
import '../models/student.dart';
import '../services/student_firestore_service.dart';

class StudentFormScreen extends StatefulWidget {
  final Student? student;

  const StudentFormScreen({super.key, this.student});

  @override
  _StudentFormScreenState createState() => _StudentFormScreenState();
}

class _StudentFormScreenState extends State<StudentFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _studentService = StudentFirestoreService();

  late String _name;
  late int _age;
  late String _course;

  @override
  void initState() {
    super.initState();
    _name = widget.student?.name ?? '';
    _age = widget.student?.age ?? 0;
    _course = widget.student?.course ?? '';
  }

  void _saveForm() {
    final isValid = _formKey.currentState!.validate();
    if (!isValid) {
      return;
    }
    _formKey.currentState!.save();

    if (widget.student == null) {
      // Add new student
      _studentService.addStudent(_name, _age, _course);
    } else {
      // Update existing student
      _studentService.updateStudent(widget.student!.id, _name, _age, _course);
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
          key: _formKey,
          child: Column(
            children: <Widget>[
              TextFormField(
                initialValue: _name,
                decoration: const InputDecoration(labelText: 'Name'),
                validator: (value) =>
                    value!.isEmpty ? 'Please enter a name.' : null,
                onSaved: (value) => _name = value!,
              ),
              TextFormField(
                initialValue: _age == 0 ? '' : _age.toString(),
                decoration: const InputDecoration(labelText: 'Age'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value!.isEmpty) return 'Please enter an age.';
                  if (int.tryParse(value) == null) return 'Please enter a valid number.';
                  if (int.parse(value) <= 0) return 'Please enter a positive age.';
                  return null;
                },
                onSaved: (value) => _age = int.parse(value!),
              ),
              TextFormField(
                initialValue: _course,
                decoration: const InputDecoration(labelText: 'Course'),
                validator: (value) =>
                    value!.isEmpty ? 'Please enter a course.' : null,
                onSaved: (value) => _course = value!,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _saveForm,
                child: const Text('Save'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
