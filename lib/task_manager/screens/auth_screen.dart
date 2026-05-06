
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  AuthScreenState createState() => AuthScreenState();
}

class AuthScreenState extends State<AuthScreen> {
  final auth = FirebaseAuth.instance;
  final formKey = GlobalKey<FormState>();
  String email = '';
  String password = '';
  bool isLogin = true;

  void trySubmit() async {
    final isValid = formKey.currentState!.validate();
    FocusScope.of(context).unfocus();

    if (isValid) {
      formKey.currentState!.save();
      try {
        if (isLogin) {
          await auth.signInWithEmailAndPassword(email: email, password: password);
        } else {
          await auth.createUserWithEmailAndPassword(email: email, password: password);
        }

        if (!mounted) return;

      } on FirebaseAuthException catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(e.message ?? 'Authentication failed.')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(isLogin ? 'Login' : 'Sign Up')),
      body: Center(
        child: Card(
          margin: const EdgeInsets.all(20),
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Form(
              key: formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextFormField(
                    key: const ValueKey('email'),
                    validator: (value) =>
                        !value!.contains('@') ? 'Invalid email' : null,
                    onSaved: (value) => email = value!,
                    keyboardType: TextInputType.emailAddress,
                    decoration: const InputDecoration(labelText: 'Email Address'),
                  ),
                  TextFormField(
                    key: const ValueKey('password'),
                    validator: (value) => value!.length < 6
                        ? 'Password must be at least 6 characters'
                        : null,
                    onSaved: (value) => password = value!,
                    decoration: const InputDecoration(labelText: 'Password'),
                    obscureText: true,
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: trySubmit,
                    child: Text(isLogin ? 'Login' : 'Sign Up'),
                  ),
                  TextButton(
                    onPressed: () => setState(() => isLogin = !isLogin),
                    child: Text(isLogin
                        ? 'Create new account'
                        : 'I already have an account'),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
