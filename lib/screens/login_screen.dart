import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
// import 'estudiante_scan_screen.dart';
import 'elegir_rol_screen.dart';
import 'role_router_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';


class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  Future<void> _signIn(BuildContext context) async {
    try {
      final googleUser = await GoogleSignIn(
        clientId: '714106175491-3dnqkn3273akn30h6ij73ij2nm3nue5b.apps.googleusercontent.com',
      ).signIn();
      if (googleUser == null) return;

      final googleAuth = await googleUser.authentication;

      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final userCredential = await FirebaseAuth.instance.signInWithCredential(credential);
      final user = userCredential.user!;
      final uid = user.uid;

      final userRef = FirebaseFirestore.instance.collection('usuarios').doc(uid);
      final doc = await userRef.get();

      if (!doc.exists) {
        await userRef.set({
          'nombre': user.displayName ?? 'Usuario sin nombre',
          'last_seen': null,
        });
      }

      final data = (await userRef.get()).data()!;
      final hasRol = data.containsKey('rol');
      final hasLastSeen = data['last_seen'] != null;

      if (!hasRol || !hasLastSeen) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => ElegirRolScreen(userId: uid)),
        );
      } else {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => RoleRouterScreen()),
        );
      }
    } catch (e) {
      print("❌ Error al iniciar sesión: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Fallo al iniciar sesión')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Iniciar sesión")),
      body: Center(
        child: ElevatedButton.icon(
          icon: Icon(Icons.login),
          label: Text("Entrar con Google"),
          onPressed: () => _signIn(context),
        ),
      ),
    );
  }
}
