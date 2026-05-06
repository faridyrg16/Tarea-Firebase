
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

void main() {
  runApp(const MyApp());
}

// 1. App de Gestión de Tareas (To-Do con usuarios)
class TaskManagerApp extends StatelessWidget {
  const TaskManagerApp({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('1. Gestión de Tareas')),
      body: const Center(child: Text('Pantalla de Gestión de Tareas')),
    );
  }
}

// 2. Sistema de Registro de Estudiantes
class StudentRegistryApp extends StatelessWidget {
  const StudentRegistryApp({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('2. Registro de Estudiantes')),
      body: const Center(child: Text('Pantalla de Registro de Estudiantes')),
    );
  }
}

// 3. Chat en Tiempo Real
class ChatApp extends StatelessWidget {
  const ChatApp({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('3. Chat en Tiempo Real')),
      body: const Center(child: Text('Pantalla de Chat')),
    );
  }
}

// 4. Sistema de Notas con Imágenes
class NotesApp extends StatelessWidget {
  const NotesApp({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('4. Notas con Imágenes')),
      body: const Center(child: Text('Pantalla de Notas con Imágenes')),
    );
  }
}

// 5. Panel de Administración de Productos
class AdminPanelApp extends StatelessWidget {
  const AdminPanelApp({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('5. Panel de Administración')),
      body: const Center(child: Text('Pantalla de Panel de Administración')),
    );
  }
}

final GoRouter _router = GoRouter(
  routes: <RouteBase>[
    GoRoute(
      path: '/',
      builder: (BuildContext context, GoRouterState state) {
        return const HomeScreen();
      },
      routes: <RouteBase>[
        GoRoute(
          path: 'task-manager',
          builder: (BuildContext context, GoRouterState state) {
            return const TaskManagerApp();
          },
        ),
        GoRoute(
          path: 'student-registry',
          builder: (BuildContext context, GoRouterState state) {
            return const StudentRegistryApp();
          },
        ),
        GoRoute(
          path: 'chat',
          builder: (BuildContext context, GoRouterState state) {
            return const ChatApp();
          },
        ),
        GoRoute(
          path: 'notes',
          builder: (BuildContext context, GoRouterState state) {
            return const NotesApp();
          },
        ),
        GoRoute(
          path: 'admin-panel',
          builder: (BuildContext context, GoRouterState state) {
            return const AdminPanelApp();
          },
        ),
      ],
    ),
  ],
);

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      routerConfig: _router,
      title: 'Firebase Mini-Apps',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
    );
  }
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Firebase Mini-Apps'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          _buildAppButton(
            context,
            '1. Gestión de Tareas',
            'task-manager',
          ),
          const SizedBox(height: 16),
          _buildAppButton(
            context,
            '2. Registro de Estudiantes',
            'student-registry',
          ),
          const SizedBox(height: 16),
          _buildAppButton(
            context,
            '3. Chat en Tiempo Real',
            'chat',
          ),
          const SizedBox(height: 16),
          _buildAppButton(
            context,
            '4. Notas con Imágenes',
            'notes',
          ),
          const SizedBox(height: 16),
          _buildAppButton(
            context,
            '5. Panel de Administración',
            'admin-panel',
          ),
        ],
      ),
    );
  }

  Widget _buildAppButton(BuildContext context, String title, String route) {
    return ElevatedButton(
      onPressed: () => context.go('/$route'),
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.symmetric(vertical: 20),
        textStyle: const TextStyle(fontSize: 18),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      child: Text(title),
    );
  }
}
