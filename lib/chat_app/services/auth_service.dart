
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'dart:developer' as developer;

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Stream<User?> get user => _auth.authStateChanges();

  Future<UserCredential?> signInWithGoogle() async {
    try {
      // Iniciar el flujo de autenticación de Google
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

      // Si el usuario cancela, googleUser será nulo
      if (googleUser == null) {
        return null;
      }

      // Obtener los detalles de autenticación de la solicitud
      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;

      // Crear una credencial de Firebase
      // El accessToken ya no está disponible en esta versión del paquete.
      // El idToken es suficiente para la autenticación con Firebase.
      final AuthCredential credential = GoogleAuthProvider.credential(
        idToken: googleAuth.idToken,
      );

      // Iniciar sesión en Firebase con la credencial
      return await _auth.signInWithCredential(credential);
    } catch (e, s) {
      developer.log(
        'Error during Google sign-in',
        name: 'auth_service.signInWithGoogle',
        error: e,
        stackTrace: s,
      );
      return null;
    }
  }

  Future<void> signOut() async {
    // Es importante cerrar la sesión tanto en Google como en Firebase
    await GoogleSignIn().signOut();
    await _auth.signOut();
  }
}
