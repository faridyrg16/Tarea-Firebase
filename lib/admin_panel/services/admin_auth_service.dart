
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/user.dart';

class AdminAuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Stream for auth state changes
  Stream<User?> get user => _auth.authStateChanges();

  // Get current user
  User? getCurrentUser() {
    return _auth.currentUser;
  }

  // Sign in with email and password
  Future<UserCredential?> signIn(String email, String password) async {
    try {
      return await _auth.signInWithEmailAndPassword(email: email, password: password);
    } catch (e) {
      print(e); // Handle error appropriately
      return null;
    }
  }

  // Register with email and password
  Future<UserCredential?> register(String email, String password) async {
    try {
      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(email: email, password: password);

      // Create a user document in Firestore
      await _firestore.collection('users').doc(userCredential.user!.uid).set({
        'email': email,
        'role': 'user', // Default role
      });

      return userCredential;
    } catch (e) {
      print(e); // Handle error appropriately
      return null;
    }
  }

  // Sign out
  Future<void> signOut() async {
    await _auth.signOut();
  }

  // Check if the current user is an admin
  Future<bool> isAdmin() async {
    final currentUser = getCurrentUser();
    if (currentUser == null) return false;

    try {
      final userDoc = await _firestore.collection('users').doc(currentUser.uid).get();
      if (userDoc.exists) {
        final appUser = AppUser.fromFirestore(userDoc);
        return appUser.role == 'admin';
      }
      return false;
    } catch (e) {
      print(e);
      return false;
    }
  }
}
