
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'services/admin_auth_service.dart';
import 'screens/admin_login_screen.dart';
import 'screens/admin_panel_screen.dart';

class AdminAuthWrapper extends StatelessWidget {
  const AdminAuthWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    final _authService = AdminAuthService();

    return StreamBuilder<User?>(
      stream: _authService.user,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(body: Center(child: CircularProgressIndicator()));
        }

        final user = snapshot.data;
        if (user == null) {
          return const AdminLoginScreen();
        }

        return FutureBuilder<bool>(
          future: _authService.isAdmin(),
          builder: (context, adminSnapshot) {
            if (adminSnapshot.connectionState == ConnectionState.waiting) {
              return const Scaffold(body: Center(child: CircularProgressIndicator()));
            }

            if (adminSnapshot.data == true) {
              return const AdminPanelScreen();
            } else {
              return Scaffold(
                appBar: AppBar(title: const Text('Unauthorized')), 
                body: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text('You do not have permission to access this page.'),
                      const SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: () => _authService.signOut(),
                        child: const Text('Logout'),
                      )
                    ],
                  ),
                ),
              );
            }
          },
        );
      },
    );
  }
}
