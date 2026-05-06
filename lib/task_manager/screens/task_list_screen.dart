import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../services/firestore_service.dart';
import '../models/task.dart';

enum TaskFilter { all, completed, pending }

class TaskListScreen extends StatefulWidget {
  const TaskListScreen({super.key});

  @override
  TaskListScreenState createState() => TaskListScreenState();
}

class TaskListScreenState extends State<TaskListScreen> {
  final FirestoreService firestoreService = FirestoreService();
  final TextEditingController taskController = TextEditingController();
  TaskFilter currentFilter = TaskFilter.all;

  void addTask() {
    if (taskController.text.isNotEmpty) {
      firestoreService.addTask(taskController.text);
      taskController.clear();
      Navigator.pop(context); // Close the dialog
    }
  }

  void showAddTaskDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('New Task'),
        content: TextField(
          controller: taskController,
          autofocus: true,
          decoration: const InputDecoration(labelText: 'Task Title'),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(onPressed: addTask, child: const Text('Add')),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Tasks'),
        actions: [
          PopupMenuButton<TaskFilter>(
            onSelected: (filter) => setState(() => currentFilter = filter),
            itemBuilder: (context) => [
              const PopupMenuItem(value: TaskFilter.all, child: Text('All')),
              const PopupMenuItem(
                value: TaskFilter.pending,
                child: Text('Pending'),
              ),
              const PopupMenuItem(
                value: TaskFilter.completed,
                child: Text('Completed'),
              ),
            ],
          ),
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () => FirebaseAuth.instance.signOut(),
          ),
        ],
      ),
      body: StreamBuilder<List<Task>>(
        stream: firestoreService.getTasks(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No tasks yet. Add one!'));
          }

          final tasks = getFilteredTasks(snapshot.data!);

          return ListView.builder(
            itemCount: tasks.length,
            itemBuilder: (context, index) {
              final task = tasks[index];
              return ListTile(
                leading: Checkbox(
                  value: task.isCompleted,
                  onChanged: (val) =>
                      firestoreService.updateTask(task.id, val!),
                ),
                title: Text(
                  task.title,
                  style: TextStyle(
                    decoration: task.isCompleted
                        ? TextDecoration.lineThrough
                        : null,
                  ),
                ),
                trailing: IconButton(
                  icon: const Icon(Icons.delete, color: Colors.red),
                  onPressed: () => firestoreService.deleteTask(task.id),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: showAddTaskDialog,
        child: const Icon(Icons.add),
      ),
    );
  }

  List<Task> getFilteredTasks(List<Task> tasks) {
    switch (currentFilter) {
      case TaskFilter.pending:
        return tasks.where((task) => !task.isCompleted).toList();
      case TaskFilter.completed:
        return tasks.where((task) => task.isCompleted).toList();
      case TaskFilter.all:
        return tasks;
    }
  }
}
