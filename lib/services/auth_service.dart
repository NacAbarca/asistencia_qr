import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // 🔹 Obtener usuario actual
  User? get currentUser => _auth.currentUser;

  // 🔹 Iniciar sesión con Google
  Future<User?> signInWithGoogle() async {
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
    if (googleUser == null) return null; // El usuario canceló

    final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
    final AuthCredential credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    final UserCredential userCredential = await _auth.signInWithCredential(credential);
    return userCredential.user;
  }

  // 🔹 Iniciar sesión con email y contraseña
  Future<User?> signInWithEmail(String email, String password) async {
    final UserCredential userCredential = await _auth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
    return userCredential.user;
  }

  // 🔹 Registrar usuario con email y contraseña
  Future<User?> registerWithEmail(String email, String password) async {
    final UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
    return userCredential.user;
  }

  // 🔹 Cerrar sesión
  Future<void> signOut() async {
    await _auth.signOut();
  }
}
