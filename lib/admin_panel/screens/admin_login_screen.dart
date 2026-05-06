
import 'package:flutter/material.dart';
import '../services/admin_auth_service.dart';

class AdminLoginScreen extends StatefulWidget {
  const AdminLoginScreen({super.key});

  @override
  AdminLoginScreenState createState() => AdminLoginScreenState();
}

class AdminLoginScreenState extends State<AdminLoginScreen> {
  final authService = AdminAuthService();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final formKey = GlobalKey<FormState>();
  bool isLogin = true;
  String? errorMessage;

  void submit() async {
    if (formKey.currentState!.validate()) {
      setState(() {
        errorMessage = null;
      });

      final user = isLogin
          ? await authService.signIn(emailController.text, passwordController.text)
          : await authService.register(emailController.text, passwordController.text);

      if (user == null) {
        setState(() {
          errorMessage = isLogin
              ? 'Failed to sign in. Check your credentials.'
              : 'Failed to register. The email might be in use.';
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(isLogin ? 'Admin Login' : 'Admin Register'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextFormField(
                  controller: emailController,
                  decoration: const InputDecoration(labelText: 'Email'),
                  validator: (value) => value!.isEmpty ? 'Enter an email' : null,
                ),
                TextFormField(
                  controller: passwordController,
                  decoration: const InputDecoration(labelText: 'Password'),
                  obscureText: true,
                  validator: (value) => value!.length < 6 ? 'Password must be at least 6 characters' : null,
                ),
                const SizedBox(height: 20),
                if (errorMessage != null)
                  Text(
                    errorMessage!,
                    style: const TextStyle(color: Colors.red),
                  ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: submit,
                  child: Text(isLogin ? 'Login' : 'Register'),
                ),
                TextButton(
                  onPressed: () {
                    setState(() {
                      isLogin = !isLogin;
                      errorMessage = null;
                    });
                  },
                  child: Text(isLogin ? 'Need an account? Register' : 'Have an account? Login'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
