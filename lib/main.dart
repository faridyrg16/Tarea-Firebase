
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'firebase_options.dart';
import 'task_manager/auth_wrapper.dart';
import 'student_registry/screens/student_list_screen.dart';
import 'chat_app/auth_wrapper.dart';
import 'admin_panel/auth_wrapper.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

// 4. Sistema de Notas con Imágenes (Placeholder)
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
            return const AuthWrapper();
          },
        ),
        GoRoute(
          path: 'student-registry',
          builder: (BuildContext context, GoRouterState state) {
            return const StudentListScreen();
          },
        ),
        GoRoute(
          path: 'chat',
          builder: (BuildContext context, GoRouterState state) {
            return const ChatAuthWrapper();
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
            return const AdminAuthWrapper();
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
